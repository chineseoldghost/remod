_"In software development, a neutral build is a build that reflects the current state of the source code checked into the source code version control system by the developers, but without any developer-specific changes."_

### What Is/Why SVN? ###
Subversion, or SVN, allows developers to keep a copy of their project on a server (an SVN Repository), from which others can download it, without having to re-upload the entire project every time changes are made. SVN tracks what files are changed and uploads/downloads only those files, as well as offer the ability to compare files from your local (working) copy with those on the server, and various other features for developers.

This is ideal for testing a mod like Remod as I don't need to upload a whole install for every test and you don't need to download it every time.

When I feel the time is ripe, an installer will be available.

### Requirements for Remod ###
  * Crysis Wars with patch 1.5 installed
  * **Visual C++ 2010 Redistributable.** (as of May 6)

## Instructions ##
These are instructions on how to get neutral builds of Remod. Tests are planned on the Crymod IRC until I start organizing "official" tests.

  1. Download TortoiseSVN for your system at http://tortoisesvn.net/downloads.
  1. Follow the installation process. The system restart is unfortunately required.
  1. Create a Remod folder in your Crysis Wars\Mods folder. If you have no Mods folder, create it.
  1. Right-click the Remod folder you made and choose SVN Checkout.
  1. You'll be greeted with a dialog. In the top input box, enter/paste http://remod.googlecode.com/svn/trunk/Remod and click OK. Make sure Fully Recursive is selected in the dropdown menu and HEAD Revision is ticked. Hit OK and let it download; the initial download will be 100+ MB.
  1. Update your working copy by right-clicking your Remod folder and choosing SVN Update. Do this before launching Remod, always.
  1. Aside from the usual ways, you can launch Remod through the Play Remod shortcut in the Remod folder.