require 'socket'
require 'json'
require 'objspace'
 
host = 'localhost'     
port = 2000                           
path = 'index.html'                 

def choose_method
	print "Method: "
	chosen_method=gets.chomp
	
	while !(chosen_method=="GET" || chosen_method=="POST")
		puts "Choose either GET or POST"
		print "Method: "
		chosen_method=gets.chomp		

	end
	
	return chosen_method
end


chosen_method=choose_method
print "Path: "
path=gets.chomp
viking_hash={}

if chosen_method=="POST"
	puts "Enter a name and email address for your viking"
	print "Name: "
	viking_name=gets.chomp
	print "Email: "
	email=gets.chomp
	viking_hash["viking"]={"name"=>viking_name, "email"=>email}
	viking=viking_hash.to_json
	request = "POST #{path} HTTP/1.0\r\nContent-Type: text/json\r\nContent-Length: #{ObjectSpace.memsize_of(viking_hash)}\r\n\r\n#{viking}"

else
	request = "GET #{path} HTTP/1.0\r\n\r\n"
end


 
socket = TCPSocket.open(host,port)  
socket.print(request)

response = socket.read              

headers,body = response.split("\r\n\r\n", 2) 
