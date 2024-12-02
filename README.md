
# Beets_manuel

The purpose of this script is to to easily and quickly perform some commands in beets


[Beets](https://beets.io/) is the media library management system for obsessive music geeks.

The purpose of beets is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes. It then provides a bouquet of tools for manipulating and accessing your music..


## Installation

Beets is a python project, we need to intall Python and create virtual env for beets and beets's dependencies. (for me to linux mint 22)

### 1 - Check python and pip3 version :
```bash
python3 --version
pip3 --version
```
_usually python is installed by default_
### 2 - Update and install pip3 :
```bash
sudo apt update
sudo apt install python3-pip
```    
### 3 - Create a virtual environment :
```bash
python3 -m venv ~/beets-env
```    
_nor required but recommended_

### 4 - Activate the virtual environment :
```bash
source ~/beets-env/bin/activate
```    
### 5 - Create an alias for this environnement (optional) :
```bash
alias beet="source ~/beets_env/bin/activate && beet"
```    
_in my .bashrc, when you'll tape "beet" in your prompt, the virtual environnement will be automatically activate._

### 6 - Install beets :
```bash
beet
pip install beets
```    

### 6 - Install dependencies :
I use many plugins for beets : fetchart, embedart, scrub, lastgenre, lyrics, duplicates, hook, discogs, missing, permissions, keyfinder, mbsync, inline, ftintitle, autobpm, badfiles, deezer, beatport4.
```bash
pip install "beets[fetchart]"
pip install "beets[embedart]"
pip install "beets[scrub]"
pip install "beets[lyrics]"
pip install "beets[lastgenre]"
pip install "beets[autobpm]"
pip install "beets[discogs]"
pip install -U discogs_client
pip install "beets-beatport4"
```
Ressources : [Beets plugins](https://beets.readthedocs.io/en/stable/plugins/index.html), [beets-beatport4 0.3.4](https://pypi.org/project/beets-beatport4/), [Issue with Discogs](https://github.com/beetbox/beets/issues/1867#issuecomment-195074596)

### 7 - make your config.yalm :

see mine in list files.

### 8 - Clone the repository :
```bash
git clone https://github.com/u2pitchjami/beets_manuel.git
```    
### 8 - Configuration :

You need 2 Configurations files in your .config/beets/config.yalm and config.yalm.manuel

in the second (config.yalm.manuel), it must the same to normal config.yalm, **exept** for import option "quiet", here set to "no"

With this files, the beets_manuel script can switch from manual to automatic mode alternately.
## Usage/Examples

```bash
bash ~/bin/beets_manuel/beets_manuel.sh
```

When you start, i made a tar save of configurations files and beets base.

You can choose between 6 possibilites :

### 1 - Manual integration

After an auto import (with quiet "on" and quiet_fallback "skip"), all skipped albums are in the log file.

So, after auto import (option 4), the script extract skipped albums lines to beetsmanuel file.

When you take option 1, the script goes on manual mode (switch conf file) and use beets_manuel files for import manually skipped albums.

### 2 - Switch manual to auto

or auto to manual for doing what do you want.

### 3 - Update beets base

for update all metadata of you beets base

### 4 - Make auto import

the script switch to auto mode and start auto import 

### 5 - Move base files

if you let beets move and renamme files, sometimes you can need to check if all files is in good place.

### 6 - quit

exit the script
## Badges

![PyPI - Python Version](https://img.shields.io/pypi/pyversions/beets)

