#!/bin/bash

# Install Apache Web Server (you can choose another server if needed)
apt-get update
apt-get install -y apache2

# Store the hostname in a variable
HOSTNAME=$(hostname)

# Create the HTML page dynamically
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Basic HTML Page</title>
</head>
<body>
    <header>
        <h1>Welcome to the LoadBalancer World</h1>
    </header>

    <section id="home">
        <p>Hostname of the system is:</p>
        <p>$HOSTNAME</p>
    </section>
</body>
</html>
EOF

# Restart Apache to serve the new content
systemctl restart apache2

