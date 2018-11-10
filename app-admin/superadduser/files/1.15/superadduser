#!/bin/bash
#
# Copyright 1995  Hrvoje Dogan, Croatia.
# Copyright 2002-2004, 2008, 2009, 2010  Stuart Winter, Surrey, England, UK.
# Copyright 2004, 2008-2010  Slackware Linux, Inc., Concord, CA, USA
# Copyright 2012  Patrick J. Volkerding, Sebeka, MN, USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
##########################################################################
# Program: /usr/sbin/adduser
# Purpose: Interactive front end to /usr/sbin/useradd for Slackware Linux
# Author : Stuart Winter <mozes@slackware.com>
#          Based on the original Slackware adduser by Hrvoje Dogan
#          with modifications by Patrick Volkerding
# Version: 1.15
##########################################################################
# Usage..: adduser [<new_user_name>]
##########################################################################
# History #
###########
# v1.15 - 2012-09-13
#       * Added scanner group, which may be required by third party drivers.
# v1.14 - 2012-08-24
#       * Added lp group, which is now required for scanning. <pjv>
# v1.13 - 13/01/10
#       * Fixed bug that removed underscore characters from UNIX group names.
#         Thanks to mRgOBLIN for the report and Jim Hawkins for the fix. <sw>
# v1.12 - 21/07/09
#       * Adjusted the search of /etc/passwd to exclude the NIS inclusion
#        string.  Thanks to Dominik L. Borkowski.
# v1.11 - 04/06/09
#       * Add power and netdev to the suggested group list
# v1.10 - 24/03/08
#       * To facilitate use of the automatic mounting features of HAL,
#         allow the admin to easily add users to the default groups:
#         audio,cdrom,video,plugdev,floppy.
#         The default is not to add new users to these groups.
#         And by the way, this script is "useradd from Slackware" not
#         "superadduser from Gentoo" ;-)
# v1.09 - 07/06/04 
#       * Added standard Slackware script licence to the head of this file.
# v1.08 - 25/04/04
#       * Disallow user names that begin with a numeric because useradd 
#         (from shadow v4.03) does not allow them. <sw>
# v1.07 - 07/03/03
#       * When supplying a null string for the uid (meaning 'Choose next available'), 
#         if there were file names in the range 'a-z' in the pwd then the 
#         egrep command considered these files rather than the null string. 
#         The egrep expression is now in quotes.  
#         Reported & fixed by Vadim O. Ustiansky <sw>
# v1.06 - 31/03/03
#       * Ask to chown user.group the home directory if it already exists.
#         This helps reduce later confusion when adding users whose home dir
#         already exists (mounted partition for example) and is owned
#         by a user other than the user to which the directory is being
#         assigned as home.  Default is not to chown.
#         Brought to my attention by mRgOBLIN. <sw>
# v1.05 - 04/01/03
#       * Advise & prevent users from creating logins with '.' characters
#         in the user name. <sw>
#       * Made pending account creation info look neater <sw>
# v1.04 - 09/06/02
#       * Catered for shadow-4.0.3's 'useradd' binary that no longer
#         will let you create a user that has any uppercase chars in it
#         This was reported on the userlocal.org forums
#         by 'xcp' - thanks. <sw,pjv>
# v1.03 - 20/05/02
#       * Support 'broken' (null lines in) /etc/passwd and 
#         /etc/group files <sw>       
#       * For recycling UIDs (default still 'off'), we now look in 
#         /etc/login.defs for the UID_MIN value and use it
#         If not found then default to 1000 <sw>
# v1.02 - 10/04/02
#       * Fix user-specified UID bug. <pjv>
# v1.01 - 23/03/02
#       * Match Slackware indenting style, simplify. <pjv>
# v1.00 - 22/03/02
#       * Created
#######################################################################

# Path to files
pfile=/etc/passwd
gfile=/etc/group
sfile=/etc/shells

# Paths to binaries
useradd=/usr/sbin/useradd
chfn=/usr/bin/chfn
passwd=/usr/bin/passwd
chmod=/bin/chmod

# Defaults
defhome=/home
defshell=/bin/bash
defchmod=711 # home dir permissions - may be preferable to use 701, however.
defgroup=users 
AGID="audio cdrom floppy plugdev video power netdev lp scanner" # additional groups for desktop users

# Determine what the minimum UID is (for UID recycling)
# (we ignore it if it's not at the beginning of the line (i.e. commented out with #))
export recycleUIDMIN="$(grep ^UID_MIN /etc/login.defs | awk '{print $2}' 2>/dev/null)"
# If we couldn't find it, set it to the default of 1000
if [ -z "$recycleUIDMIN" ]; then
   export recycleUIDMIN=1000  # this is the default from Slackware's /etc/login.defs
fi


# This setting enables the 'recycling' of older unused UIDs.
# When you userdel a user, it removes it from passwd and shadow but it will
# never get used again unless you specify it expliticly -- useradd (appears to) just
# look at the last line in passwd and increment the uid.  I like the idea of 
# recycling uids but you may have very good reasons not to (old forgotten
# confidential files still on the system could then be owned by this new user).
# We'll set this to no because this is what the original adduser shell script
# did and it's what users expect.
recycleuids=no

# Function to read keyboard input.
# bash1 is broken (even ash will take read -ep!), so we work around
# it (even though bash1 is no longer supported on Slackware).
function get_input() { 
  local output
  if [ "`echo $BASH_VERSION | cut -b1`" = "1" ]; then
    echo -n "${1} " >&2 # fudge for use with bash v1
    read output
  else # this should work with any other /bin/sh
    read -ep "${1} " output
  fi
  echo $output
}

# Function to display the account info
function display () {
  local goose
  goose="$(echo $2 | cut -d ' ' -f 2-)"  # lop off the prefixed argument useradd needs
  echo -n "$1 "
  # If it's null then display the 'other' information
  if [ -z "$goose" -a ! -z "$3" ]; then 
    echo "$3" 
  else 
    echo "$goose" 
  fi
}

# Function to check whether groups exist in the /etc/group file
function check_group () {
  local got_error group
  if [ ! -z "$@" ]; then  
  for group in $@ ; do
    local uid_not_named="" uid_not_num=""
    grep -v "$^" $gfile | awk -F: '{print $1}' | grep "^${group}$" >/dev/null 2>&1 || uid_not_named=yes  
    grep -v "$^" $gfile | awk -F: '{print $3}' | grep "^${group}$" >/dev/null 2>&1 || uid_not_num=yes
    if [ ! -z "$uid_not_named" -a ! -z "$uid_not_num" ]; then
      echo "- Group '$group' does not exist"
      got_error=yes
    fi
  done
  fi
  # Return exit code of 1 if at least one of the groups didn't exist
  if [ ! -z "$got_error" ]; then
    return 1
  fi
}   

#: Read the login name for the new user :#
#
# Remember that most Mail Transfer Agents are case independant, so having
# 'uSer' and 'user' may cause confusion/things to break.  Because of this,
# useradd from shadow-4.0.3 no longer accepts usernames containing uppercase,
# and we must reject them, too.

# Set the login variable to the command line param
echo
LOGIN="$1"
needinput=yes
while [ ! -z $needinput ]; do
  if [ -z "$LOGIN" ]; then 
    while [ -z "$LOGIN" ]; do LOGIN="$(get_input "Login name for new user []:")" ; done
  fi
  grep "^${LOGIN}:" $pfile >/dev/null 2>&1  # ensure it's not already used
  if [ $? -eq 0 ]; then
    echo "- User '$LOGIN' already exists; please choose another"
    unset LOGIN
  elif [ ! -z "$( echo $LOGIN | grep "^[0-9]" )" ]; then
    echo "- User names cannot begin with a number; please choose another"
    unset LOGIN
  elif [ ! "$LOGIN" = "`echo $LOGIN | tr A-Z a-z`" ]; then # useradd does not allow uppercase
    echo "- User '$LOGIN' contains illegal characters (uppercase); please choose another"
    unset LOGIN
  elif [ ! -z "$( echo $LOGIN | grep '\.' )" ]; then
    echo "- User '$LOGIN' contains illegal characters (period/dot); please choose another"
    unset LOGIN
  else
    unset needinput
  fi
done

# Display the user name passed from the shell if it hasn't changed
if [ "$1" = "$LOGIN" ]; then
  echo "Login name for new user: $LOGIN"
fi

#: Get the UID for the user & ensure it's not already in use :#
#
# Whilst we _can_ allow users with identical UIDs, it's not a 'good thing' because
# when you change password for the uid, it finds the first match in /etc/passwd 
# which isn't necessarily the correct user
#
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  _UID="$(get_input "User ID ('UID') [ defaults to next available ]:")"
  egrep -v "^$|^\+" $pfile | awk -F: '{print $3}' | grep "^${_UID}$" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "- That UID is already in use; please choose another"
  elif [ ! -z "$(echo $_UID | egrep '[A-Za-z]')" ]; then
    echo "- UIDs are numerics only"         
  else
    unset needinput
  fi
done
# If we were given a UID, then syntax up the variable to pass to useradd
if [ ! -z "$_UID" ]; then 
  U_ID="-u ${_UID}"
else
  # Will we be recycling UIDs?
  if [ "$recycleuids" = "yes" ]; then
    U_ID="-u $(awk -F: '{uid[$3]=1} END { for (i=ENVIRON["recycleUIDMIN"];i in uid;i++);print i}' $pfile)"
  fi   
fi

#: Get the initial group for the user & ensure it exists :#
#
# We check /etc/group for both the text version and the group ID number 
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  GID="$(get_input "Initial group [ ${defgroup} ]:")"
  check_group "$GID"
  if [ $? -gt 0 ]; then
    echo "- Please choose another"
  else
    unset needinput 
  fi
done
# Syntax the variable ready for useradd
if [ -z "$GID" ]; then
  GID="-g ${defgroup}"
else
  GID="-g ${GID}"
fi

#: Get additional groups for the user :#
#
echo "Additional UNIX groups:"
echo
echo "Users can belong to additional UNIX groups on the system."
echo "For local users using graphical desktop login managers such"
echo "as XDM/KDM, users may need to be members of additional groups"
echo "to access the full functionality of removable media devices."
echo
echo "* Security implications *"
echo "Please be aware that by adding users to additional groups may"
echo "potentially give access to the removable media of other users."
echo
echo "If you are creating a new user for remote shell access only,"
echo "users do not need to belong to any additional groups as standard,"
echo "so you may press ENTER at the next prompt."
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  history -c
  history -s "$AGID"
  echo "Press ENTER to continue without adding any additional groups"
  echo "Or press the UP arrow key to add/select/edit additional groups"
  AGID="$(get_input ": " | sed 's/[^A-Za-z0-9 _]//g;s/  */ /g;s/^ $//g' )"
  if [ ! -z "$AGID" ]; then
    check_group "$AGID" # check all groups at once (treated as N # of params)
    if [ $? -gt 0 ]; then
      echo "- Please re-enter the group(s)"
      echo
    else
      unset needinput # we found all groups specified
      AGID="-G $(echo $AGID | tr ' ' ,)" # useradd takes comma delimited groups
    fi
  else
    unset needinput # we don't *have* to have additional groups
  fi
done

#: Get the new user's home dir :#
#       
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  HME="$(get_input "Home directory [ ${defhome}/${LOGIN} ]")"
  if [ -z "$HME" ]; then
    HME="${defhome}/${LOGIN}"
  fi 
  # Warn the user if the home dir already exists
  if [ -d "$HME" ]; then
    echo "- Warning: '$HME' already exists !"
    getyn="$(get_input "  Do you wish to change the home directory path ? (Y/n) ")"
    if [ "$(echo $getyn | grep -i "n")" ]; then
      unset needinput
      # You're most likely going to only do this if you have the dir *mounted* for this user's $HOME
      getyn="$(get_input "  Do you want to chown $LOGIN.$( echo $GID | awk '{print $2}') $HME ? (y/N) ")"
      if [ "$(echo $getyn | grep -i "y")" ]; then
         CHOWNHOMEDIR=$HME # set this to the home directory
      fi
    fi
  else
    unset needinput
  fi
done           
HME="-d ${HME}"  
    
#: Get the new user's shell :#
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  unset got_error
  SHL="$(get_input "Shell [ ${defshell} ]")"
  if [ -z "$SHL" ]; then
    SHL="${defshell}"
  fi 
  # Warn the user if the shell doesn't exist in /etc/shells or as a file
  if [ -z "$(grep "^${SHL}$" $sfile)" ]; then
    echo "- Warning: ${SHL} is not in ${sfile} (potential problem using FTP)"
    got_error=yes
  fi
  if [ ! -f "$SHL" ]; then
    echo "- Warning: ${SHL} does not exist as a file"
    got_error=yes
  fi
  if [ ! -z "$got_error" ]; then
    getyn="$(get_input "  Do you wish to change the shell ? (Y/n) ")"
    if [ "$(echo $getyn | grep -i "n")" ]; then
      unset needinput
    fi
  else
    unset needinput
  fi
done           
SHL="-s ${SHL}"

#: Get the expiry date :#
echo
needinput=yes
while [ ! -z "$needinput" ]; do
  EXP="$(get_input "Expiry date (YYYY-MM-DD) []:")"
  if [ ! -z "$EXP" ]; then
    # Check to see whether the expiry date is in the valid format
    if [ -z "$(echo "$EXP" | grep "^[[:digit:]]\{4\}[-]\?[[:digit:]]\{2\}[-]\?[[:digit:]]\{2\}$")" ]; then
      echo "- That is not a valid expiration date"
    else
      unset needinput 
      EXP="-e ${EXP}" 
    fi
  else
    unset needinput
  fi
done

# Display the info about the new impending account
echo
echo "New account will be created as follows:"
echo
echo "---------------------------------------"
display "Login name.......: " "$LOGIN"
display "UID..............: " "$_UID" "[ Next available ]"
display "Initial group....: " "$GID"
display "Additional groups: " "$AGID" "[ None ]"
display "Home directory...: " "$HME"
display "Shell............: " "$SHL"
display "Expiry date......: " "$EXP" "[ Never ]"
echo

echo "This is it... if you want to bail out, hit Control-C.  Otherwise, press"
echo "ENTER to go ahead and make the account."
read junk

echo
echo "Creating new account..."
echo
echo

# Add the account to the system
CMD="$useradd "$HME" -m "$EXP" "$U_ID" "$GID" "$AGID" "$SHL" "$LOGIN""
$CMD

if [ $? -gt 0 ]; then
  echo "- Error running useradd command -- account not created!"
  echo "(cmd: $CMD)"
  exit 1
fi

# chown the home dir ?  We can only do this once the useradd has
# completed otherwise the user name doesn't exist.
if [ ! -z "${CHOWNHOMEDIR}" ]; then
  chown "$LOGIN"."$( echo $GID | awk '{print $2}')" "${CHOWNHOMEDIR}"
fi

# Set the finger information
$chfn "$LOGIN"
if [ $? -gt 0 ]; then
  echo "- Warning: an error occurred while setting finger information"
fi

# Set a password
$passwd "$LOGIN"
if [ $? -gt 0 ]; then
  echo "* WARNING: An error occured while setting the password for"
  echo "           this account.  Please manually investigate this *"
  exit 1
fi

# If it was created (it should have been!), set the permissions for that user's dir 
HME="$(echo "$HME" | awk '{print $2}')"  # We have to remove the -g prefix
if [ -d "$HME" ]; then
  $chmod $defchmod "$HME"
fi

echo
echo
echo "Account setup complete."
exit 0
