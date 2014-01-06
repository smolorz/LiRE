import socket
import hashlib

class LireBaseSocketClass(object):

    def recv_word(self, sock):
        """Receive from sock until '\n'"""
        word = ""
        while True:
            token = sock.recv(1)
            if token == '\n':
                break
            else:
                word += token
        if word.strip() == "":
            print "received empty word."
            word = self.recv_word(sock)
        if word.split(":")[0] == "ERROR":
            print "An Error occcured: %s" % word.split(":")[1]
            self.clean_up()
        return word

    def recv_file(self, sock, target):
        """Receive a file from sock and write it to target"""
        print "recieving %s" % target
        target = file(target, 'wb')
        while True:
            data = sock.recv(1024)
            if not data:
                break
            else:
                target.write(data)
        target.flush()
        target.close()

    def send_word(self, sock, data):
        """Wrapper function around sock.send(msg) to make debugging and errorhandling cleaner"""
        try:
            sock.send(data + '\n')
        except socket.error as e:
            self.clean_up()
            raise e

    def send_file(self, sock, path):
        print "Sending file: %s" % path
        out_file = file(path, 'r')
        sock.sendall(out_file.read())

    def clean_up(self):
        print "DUMMY CLEAN_UP"

    def create_md5(self, path):
        md5sum = hashlib.md5()
        md5sum.update(file(path, 'r').read())
        return md5sum.hexdigest()



