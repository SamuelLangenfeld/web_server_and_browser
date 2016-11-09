require 'socket'
require 'json'
require 'objspace'

def find_file

end
def get_request(path)
	#find file
	#send it back

	status_line="HTTP/1.0 200 OK\r\n"

	file=File.read(path)
	date="Date: #{Time.now.ctime}\r\n"
	content_type="Content-Type: text/html\r\n"
	body="\r\n\r\n #{file}"
	content_length="content_length: #{ObjectSpace.memsize_of(body)}"


	return "#{status_line}#{date}#{content_type}#{content_length}#{body}"
		
	
end

def post_request(body, path)
	
	params=JSON.parse(body)
	
	viking=params["viking"]
	
	viking_name=viking["name"]
	
	email=viking["email"]
	

	file=File.read(path).gsub(/<%= yield %>/) { |match|  "<li>name: "+viking_name+"</li><li>email: "+email+"</li>"}
	File.open("#{viking_name}_"+"thanks.html", "w") { |io| io.puts file }




end



def file_not_found_response
	status_line="HTTP/1.0 404 Not Found\r\n\r\n"
	return status_line
end


server = TCPServer.open(2000)
loop {
	Thread.start(server.accept) do |client|
		

		request= client.recv(1000)

		
	

		
		request_split = request.split("\r\n\r\n")

		
		header=request_split.first

		body=request_split[1]

		

		method_type=header.split[0]

		path=header.split[1]

		response=""

		if File.exists?(path)
			

			case method_type
			when "GET"
				response=get_request(path)
			when "POST"

				response=post_request(body, path)

			else
				client.puts "HTTP/1.0 440 Bad Request\r\n\r\n"

			end


			client.print(response)

		else
			client.puts(file_not_found_response)
		end





		client.close
	end
}


