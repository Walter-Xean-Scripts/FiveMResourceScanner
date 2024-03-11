## FiveM Script Scanner
Since it's become more popular for kids to try with their *shitty* attempts at infecting your server through encrypted code, I've made this litte scanner to go through your servers resources and flag for certain things. It doesn't do that much right now, but I'd say it still can be useful for some people.

### Current Checks
Right now all this does is check for hex encoded strings, that are very often used to hide native names so you can't search for them. A very common approach these people will do, is make a http request to their backend, and run some code from the response.

I might be adding more checks for different things in the future, given that I get told about more exploits and I find it relevant to add.

### Why use this tool?
There's other tools that scans for different patterns and such, which I'm sure also could get the job done. What I noticed was that they ran through started resources, which in some cases, isn't very optimal. Some of these exploits activly spread through other resources, so it's best to deal with the malicious code before running the scripts. That's where this tool comes in! I scan through all stopped (configurable) resources on the server, and look for any hex encoded strings. Then as a little bonus I've added a feature that decrypts these strings and tells you what they are. Also we output all the results to a file, so you view them easier.

### Risks
There shouldn't be any risks connected to this tool, since we by standard operate on stopped resources. That means that malicious code shouldn't be able to detect us, while we can still go through code of other scripts. Also if you're worried about this tool itself being malicious, you can always check the source code it's not very many lines and it's available right on this page.

### How to use
1. Go to your server.cfg (resources.cfg/wherever you start your resources) and remove all your started/ensured resources. This is to start your server up without any running resources.
2. Start your now empty server, and wait for it to ready up.
3. Clone this repository to your resources folder, type `refresh` in the console and start the resource. (`ensure FiveMResourceScanner`)
4. Wait for the script to finish, it'll tell you when it's done. If you have a lot of scripts it might take a while and spam your console a bit.
5. Check the output.txt file in the resource folder, and read through the results.

### What to look for
Right now as I've explained we only check for hexed strings, so be on the lookout for part of the output starting with "Found hex encoded strings in". If you get this output it'll tell you the resource name and file it comes from. It will also attempt to decode the string and tell you what they are. This should be below the line we just talked about.

A good rule of thumb is to remove any encrypted code from your resources, there's really no good way to defend it being there. If it's a paid resource, they're not allowed to encrypt code themselves and must use asset escrow. If it's a free resource, it should be open and free for you to read. If this breaks a certain script, I would heavily recommend you to not use it - I get that some people hide their code to prevent theft, but if you're not 100% certain what it does, it's not worth the risk.

### False Positives
The current detection isn't 100% accurate, and might give you some false positives. Especially if it's not outputting any decoded strings, then it *could* just be the detection not working properly. If you're unsure, please do ask someone that has experience to verify that it's not malicious. I can't make any promises, but maybe we can help you over at the WXS Discord. And if not, another member there might be able to help you out.

### Discord/Support
I won't promise that I'll do support for anything related to this resource, I like to help out where I can, but I'm also pretty busy most of the time with other projects. But it could be worth a shot to head over to [Our Discord](https://discord.com/invite/tpJE2854th) and ask for help there.
