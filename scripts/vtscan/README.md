vtscan
======

Use the VirusTotal API to scan a url or file hash

This command line tool is intended to be installed in /usr/bin/ and be called like a normal command line application. It can be run from anywhere, but this is its intended location.
Note that the file scan takes the name/path of a file and the script will get the hash itself. You don't have to worry about grabbing that. 

### Setup
 - For this script, you will need to obtain a VirusTotal Public API key from [VirusTotal](http://virustotal.com). This is free and the public license should cover personal use such as this.  
 - Once you have obtained this, place the key value **in between the single quotes on line 8** of the vtcheck script.  
 - run the following command to ensure that the script is executable:    
```chmod +x vtcheck```  
 - That's it. The script should be ready to run.  

### Usage:
```vtcheck -[u | f [ v | p ] | ? ] [file_name...]```

#### Arguments:
u - check url  
f - check file  
v - verbose output. This will output a list of the services that consider a url or file to be malicious.  
p - output a permalink to the VT report.  
? - print a list of the arguments and proper usage of the tool.

Example:
```
vtcheck -fv [filename]
vtcheck -up [url]
etc.

```
