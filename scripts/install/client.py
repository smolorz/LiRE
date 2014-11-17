#!/usr/bin/env /usr/bin/python
import socket
import sys
import os.path
import time

import lire_base_socket_class

class Client(lire_base_socket_class.LireBaseSocketClass):
    def __init__(self, ip, port, lire_root_dir_tar_path, lire_out_dir):
        self.ip = ip
        self.port = port
        self.lire_tar = lire_root_dir_tar_path
        self.out_dir = lire_out_dir
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.sock.connect((self.ip, self.port))
        except socket.error as e:
            print e
            self.clean_up()
            sys.exit(1)

    def open_transport_connection(self, port):
        port = int(port)
        #fix racecondition
        time.sleep(2)
        data_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            data_sock.connect((self.ip, port))
        except socket.error as e:
            print e
            print "Unable to open connection for data-transfer"
            self.clean_up()
            sys.exit(1)
        return data_sock

    def handle_send_request(self, arg):
        file_ , port = arg.split("!")
        data_sock = self.open_transport_connection(port)
        if file_ == "lire_root_tar":
            self.send_file(data_sock, self.lire_tar)
        data_sock.close()
    
    def handle_send_md5(self, arg):
        if arg == "lire_root_tar":
            file_ = self.lire_tar
        elif arg == "lire.tar.bz2":
            file_ = os.path.join(self.out_dir, "lire.tar.bz2")
        md5sum = self.create_md5(file_)
        self.send_word(self.sock, "MD5:%s" % md5sum)

    def handle_recv_request(self, arg):
        file_, port = arg.split("!")
        data_sock = self.open_transport_connection(port)
        self.recv_file(data_sock, os.path.join(self.out_dir, "lire.tar.bz2"))

    def handle(self, answer):
        cmd = answer.split(":")[0]
        arg = answer.split(":")[1]

        if cmd == "ERROR":
            print "ERROR: %s" % arg
            self.clean_up()

        elif cmd == "ECHO":
            print "Server: %s" % arg

        elif cmd == "SEND":
            self.handle_send_request(arg)

        elif cmd == "MD5":
            self.handle_send_md5(arg)

        elif cmd == "RECV":
            self.handle_recv_request(arg)

        elif cmd == "END":
            print arg
            sys.exit(0)

    def start(self):
        while True:
            answer = self.recv_word(self.sock)
            self.handle(answer)
    
    def clean_up(self):
        sys.exit(1)
        

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print "USAGE: %s HOST PORT Lire_root_dir.tar.bz2 out_dir"
        sys.exit(1)
    else:
        Client(sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]).start()
