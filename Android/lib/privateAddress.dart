/*
  This is a current hardcoded implementation of getting the IPv4 address of the backend server.
  Current server , where the database and APIs are, has to have the address of your private IPv4
  because it is ran through docker image and hosted on your own computer.
  You can get it with ipconfig and it is shown in your main WLAN or ETH interface you use.
  In future, we will have a static address of a server provided and hosted by SICK Mobilisis
 */
String returnAddress(){
  return '192.168.1.11'; //replace with the IPv4 of your WLAN or ETH interface
}