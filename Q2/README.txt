#I'll create a complete scenario with a Dockerized Nginx web server
#and walk through troubleshooting a "host not found" issue similar to my internal dashboard problem.
Step 1: Create the Dockerized Nginx Environment
 	#Create a simple Dockerfile
 	#Create a sample index.html
 	#Build and run the container
 	docker build -t internal-dashboard .
 	docker run -d --name dashboard -p 8080:80 internal-dashboard
Step 2: Simulate the DNS Issue
	# First, verify it works normally
	curl -H "Host: internal.example.com" http://localhost:8080

	Now break the DNS resolution by messing with the host's DNS config
	# (This is just for simulation - don't do this on production systems!)
	sudo mv /etc/resolv.conf /etc/resolv.conf.backup
	echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
