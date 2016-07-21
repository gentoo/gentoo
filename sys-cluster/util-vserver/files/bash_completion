# Completion for the vserver command. Source this file (or on some systems
# add it to ~/.bash_completion and start a new shell) and bash's completion
# mechanism will know all about vserver's options!
#
# Copyright (C) Thomas Champagne <lafeuil@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# The latest version of this software can be obtained here:
#
# http://linux-vserver.org/Vserver+Completion
#
# version 0.4.0

have vserver-info && {
: ${UTIL_VSERVER_VARS:=$(vserver-info - SYSINFO |grep prefix: | awk '{ print $2}')/lib/util-vserver/util-vserver-vars}

test -e "$UTIL_VSERVER_VARS" && {

. "$UTIL_VSERVER_VARS"
. "$_LIB_FUNCTIONS"

_vserver() {
	local cur cmds cmdOpts cmdMethodOpts helpCmds names names_pipe func i j method

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	# find available vServers:
	# call function getAllVservers in vserver library
	getAllVservers names
	names_pipe=`echo ${names[@]} | sed 's/ /|/g'`

	# available commands
	cmds='start stop restart condrestart suexec exec enter chkconfig \
	running status unify pkg apt-get apt-config apt-cache \
	rpm pkgmgmt delete'

	# options (long and short name)
	cmdOpts='--help --version --debug --defaulttty -s --sync -v \
	--verbose --silent --'

	cmdMethodOpts='-m -n --context --confdir --lockfile \
	--hostname --netdev --netbcast --netmask \
	--netprefix --interface --cpuset \
	--cpusetcpus --cpusetmems --cpusetvirt \
	--initstyle --flags --help --'

	# if the previous option is a single option
	helpCmds='--help|--version'
	if [[ ${COMP_WORDS[1]} == @($helpCmds) ]] ; then
		return 0
	fi

	# lookup the vServer name
	for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )); do
		if [[ ${COMP_WORDS[i]} == @($names_pipe) ]] ; then
			# found it!
			break
		fi
	done

	#a vserver has been found
	if (( $i < ${#COMP_WORDS[@]}-1 )) ; then
		# Show the vserver command without build
		case "${COMP_WORDS[i+1]}" in
			start)
				COMPREPLY=( $( compgen -W "--rescue --rescue-cmd" -- $cur ) )
				;;
			# No completion for apt-config
			stop|restart|condrestart|enter|running|status|apt-config|delete)
				;;
			suexec)
				# I don't know how to do
				COMPREPLY=( $( compgen -W  -- $cur ) )
				;;
			exec)
				#I don't know how to do
				COMPREPLY=( $( compgen -W "" -- $cur ) )
				;;
			unify)
				COMPREPLY=( $( compgen -W "-R" -- $cur ) )
				;;
			apt-get|apt-cache)
				func=${COMP_WORDS[i+1]}
				COMP_WORDS=( ${COMP_WORDS[@]:$((i+1))} )
				COMP_CWORD=$((COMP_CWORD-i-1))
				declare -f _${func//-/_} > /dev/null && _${func//-/_}
				;;
			*)
				COMPREPLY=( $( compgen -W "$cmds" -- $cur ) )
				;;
		esac
		return 0
	else
		#no vserver name found
		prev=${COMP_WORDS[COMP_CWORD-1]}

		#search the new name of vserver
		for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )) ; do
			if [[ ${COMP_WORDS[i]} == !(vserver|-*) ]] ; then
				# found it!
				break
			fi
		done

		if (( $i < ${#COMP_WORDS[@]}-1 )) ; then
			j=$i
			i=${#COMP_WORDS[@]}
			for (( ; j < ${#COMP_WORDS[@]}-1; j++ )) ; do
				if [[ ${COMP_WORDS[j]} == "--" ]];  then
					# method's parameter
					case "$method" in
						legacy|copy)
							;;
						apt-rpm)
							COMPREPLY=( $( compgen -W "-d" -- $cur ) )
							;;
						yum)
							COMPREPLY=( $( compgen -W "-d" -- $cur ) )
							;;
						rpm)
							COMPREPLY=( $( compgen -W "-d --empty --force --nodeps" -- $cur ) )
							;;
						skeleton)
							;;
						debootstrap)
							COMPREPLY=( $( compgen -W "-d -m -s --" -- $cur ) )
							;;
						*)
							;;
					esac
					return 0
					break
				fi

				if [[ ${COMP_WORDS[j]} == @(build|-m) ]];  then
					i=$j
					if (( $j+1 < ${#COMP_WORDS[@]}-1 )) ; then
						method=${COMP_WORDS[j+1]}
					fi
				fi
			done

			if (( $i < ${#COMP_WORDS[@]}-1 )) ; then
				case $prev in
					--help)
						;;
					-n|--context|--confdir|--lockfile|--hostname|--netdev|--netbcast|--netmask|--netprefix|--interface|--cpuset|--cpusetcpus|--cpusetmems|--cpusetvirt|--initstyle|--flags)
						COMPREPLY=( $( compgen -W "" -- $cur ) )
						;;
					-m)
						COMPREPLY=( $( compgen -W "legacy copy apt-rpm yum rpm skeleton debootstrap" -- $cur ) )
						;;
					*)
						COMPREPLY=( $( compgen -W "$cmdMethodOpts" -- $cur ) )
						;;
				esac
			else
				COMPREPLY=( $( compgen -W "build" -- $cur ) )
			fi
		else
			COMPREPLY=( $( compgen -W "${names[@]} $cmdOpts" -- $cur ) )
		fi

		return 0
	fi

	return 0
}

complete -F _vserver vserver

_vapt_rpm_yum()
{
	local cur cmds cmdOpts helpCmds names func i

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	# options (long and short name)
	cmdOpts='--help --version --quiet -q --all'

	# if the previous option is a single option
	helpCmds='--help|--version'

	if [[ "${COMP_WORDS[1]}" == "@($helpCmds)" ]] ; then
		return 0
	fi

	# search --
	for (( i=0; i < ${#COMP_WORDS[@]}-1; i++ )) ; do
		if [[ ${COMP_WORDS[i]} = "--" ]] ; then
			# found it!
			break
		fi
	done

	# find available vServers
	# call function getAllVservers in vserver library
	getAllVservers names
	names_pipe=`echo ${names[@]}" --all" | sed 's/ /|/g'`

	if (( $i < ${#COMP_WORDS[@]}-1 )) && (( $i < $COMP_CWORD )) ; then
		func=${COMP_WORDS[0]:1}
		COMP_WORDS=( $func ${COMP_WORDS[@]:$((i+1))} )
		COMP_CWORD=$((COMP_CWORD-i))
		declare -f _${func//-/_} > /dev/null && _${func//-/_}
	else
		# search vServer name
		for (( i=0; i <  ${#COMP_WORDS[@]}-1; i++ )) ; do
			if [[ ${COMP_WORDS[i]} == @($names_pipe) ]] ; then
				# found it!
				break
			fi
		done

		if (( $i < ${#COMP_WORDS[@]}-1 )) ; then
			if [[ "${COMP_WORDS[i]}" = "--all"  ]] ; then
				cmdOpts='--'
				COMPREPLY=( $( compgen -W "$cmdOpts" -- $cur ) )
			else
				cmdOpts='--'
				COMPREPLY=( $( compgen -W "${names[@]} $cmdOpts" -- $cur ) )
			fi
		else
			COMPREPLY=( $( compgen -W "${names[@]} $cmdOpts" -- $cur ) )
		fi
	fi

	return 0
}

_vserver_copy()
{
	local cur prev cmdOpts helpCmds confCmds names names_pipe i

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}

	# find available vServers
	# call function getAllVservers in vserver library
	getAllVservers names
	names_pipe=`echo ${names[@]} | sed 's/ /|/g'`

	# options (long and short name)
	cmdOpts='--help -h --version -V --verbose -v --quiet -q \
		 --vsroot -r --rsh -R --stopstart -s \
		 --domain -d --ip -i'

	# if the previous option is a single option
	helpCmds='--help|-h|--version|-V'

	if [[ ${COMP_WORDS[1]} == @($helpCmds) ]] ; then
		return 0
	fi

	confCmds='--ip|-i|--domain|-d'
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [[ $prev == @($confCmds) ]] ; then
		return 0
	fi

	# search a vServer name
	for (( i=0; i <  ${#COMP_WORDS[@]}-1; i++ )); do
		if [[ ${COMP_WORDS[i]} == @($names_pipe) ]] ; then
			# found it!
			break
		fi
	done

	if (( $i < ${#COMP_WORDS[@]}-1 )) ; then
		return 0
	else
		COMPREPLY=( $( compgen -W "${names[@]} $cmdOpts" -- $cur ) )
	fi

	return 0
}

complete -F _vapt_rpm_yum vapt-get
complete -F _vapt_rpm_yum vrpm
complete -F _vapt_rpm_yum vyum
complete -F _vserver_copy vserver-copy

}
}
