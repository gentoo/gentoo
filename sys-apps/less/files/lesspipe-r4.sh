#!/bin/bash
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Preprocessor for 'less'. Used when this environment variable is set:
# LESSOPEN="|lesspipe %s"

# TODO: handle compressed files better

[[ -n ${LESSDEBUG+set} ]] && set -x

trap 'exit 0' PIPE

guesscompress() {
	case "$1" in
		*.gz|*.z)   echo "gunzip -c" ;;
		*.bz2|*.bz) echo "bunzip2 -c" ;;
		*.lz)       echo "lzip -dc" ;;
		*.lzma)     echo "unlzma -c" ;;
		*.lzo)      echo "lzop -dc" ;;
		*.xz)       echo "xzdec" ;;
		*.zst)      echo "zstdcat" ;;
		*)          echo "cat" ;;
	esac
}

crl_filter() {
	if command -v certtool &>/dev/null; then
		certtool --crl-info --text --infile "$1"
	else
		openssl crl -hash -text -noout -in "$1"
	fi
}

csr_filter() {
	if command -v certtool &>/dev/null; then
		certtool --crq-info --text --infile "$1"
	else
		openssl req -text -noout -in "$1"
	fi
}

crt_filter() {
	if command -v certtool &>/dev/null; then
		certtool --certificate-info --text --infile "$1"
	else
		openssl x509 -hash -text -noout -in "$1"
	fi
}

jks_filter() {
	if command -v keytool &>/dev/null; then
		keytool -list -keystore "$1"
	else
		cat "$1"
	fi
}

p12_filter() {
	openssl pkcs12 -nokeys -info -in "$1"
}

lesspipe_file() {
	local out=$(file -L -- "$1")
	local suffix
	case ${out} in
		*" 7-zip archive"*) suffix="7z";;
		*" ar archive"*)    suffix="a";;
		*" CAB-Installer"*) suffix="cab";;
		*" cpio archive"*)  suffix="cpio";;
		*" ELF "*)          suffix="elf";;
		*" LHa"*archive*)   suffix="lha";;
		*" troff "*)        suffix="man";;
		*" script text"*)   suffix="sh";;
		*" shared object"*) suffix="so";;
		*" tar archive"*)   suffix="tar";;
		*" Zip archive"*)   suffix="zip";;
		*": data")          hexdump -C -- "$1"; return 0;;
		*)                  return 1;;
	esac
	lesspipe "$1" ".${suffix}"
	return 0
}

lesspipe() {
	local match=$2
	[[ -z ${match} ]] && match=$1

	local DECOMPRESSOR=$(guesscompress "${match}")

	# User filters
	if [[ -x ~/.lessfilter ]] ; then
		~/.lessfilter "$1" && exit 0
	fi

	# System filters
	shopt -s nullglob
	local f
	for f in "${XDG_CONFIG_HOME:-~/.config}"/lessfilter.d/* /etc/lessfilter.d/* /usr/lib/lessfilter.d/*; do
		if [[ -x ${f} ]]; then
			"${f}" "$1" && exit 0
		fi
	done
	shopt -u nullglob

	local ignore
	for ignore in ${LESSIGNORE} ; do
		[[ ${match} == *.${ignore} ]] && exit 0
	done

	# Handle non-regular file types.
	if [[ -d $1 ]] ; then
		ls -alF -- "$1"
		return
	elif [[ ! -f $1 ]] ; then
		# Only return if the stat passes.  This is needed to handle pseudo
		# arguments like URIs.
		stat -- "$1" && return
	fi

	case "${match}" in

	### Doc files ###
	*.[0-9n]|*.man|\
	*.[0-9n].bz2|*.man.bz2|\
	*.[0-9n].gz|*.man.gz|\
	*.[0-9n].lzma|*.man.lzma|\
	*.[0-9n].xz|*.man.xz|\
	*.[0-9n].zst|*.man.zst|\
	*.[0-9][a-z].gz|*.[0-9][a-z].gz)
		local out=$(${DECOMPRESSOR} -- "$1" | file -)
		case ${out} in
			*troff*)
				# Need to make sure we pass path to man or it will try
				# to locate "$1" in the man search paths
				if [[ $1 == /* ]] ; then
					man -- "$1"
				else
					man -- "./$1"
				fi
				;;
			*text*)
				${DECOMPRESSOR} -- "$1"
				;;
			*)
				# We could have matched a library (libc.so.6), so let
				# `file` figure out what the hell this thing is
				lesspipe_file "$1"
				;;
		esac
		;;
	*.dvi)      dvi2tty "$1" ;;
	*.ps)       ps2ascii "$1" || pstotext "$1" ;;
	*.pdf)      pdftotext "$1" - || ps2ascii "$1" || pstotext "$1" ;;
	*.doc)      antiword "$1" || catdoc "$1" ;;
	*.rtf)      unrtf --nopict --text "$1" ;;
	*.conf|*.txt|*.log) ;; # force less to work on these directly #150256
	*.json)     python -mjson.tool "$1" ;;

	### URLs ###
	ftp://*|http://*|https://|*.htm|*.html)
		for b in elinks links2 links lynx ; do
			${b} -dump "$1" && exit 0
		done
		html2text -style pretty "$1"
		;;

	### Tar files ###
	*.tar|\
	*.tar.bz2|*.tar.bz|*.tar.gz|*.tar.z|*.tar.zst|\
	*.tar.lz|*.tar.tlz|\
	*.tar.lzma|*.tar.xz)
		${DECOMPRESSOR} -- "$1" | tar tvvf -;;
	*.tbz2|*.tbz|*.tgz|*.tlz|*.txz)
		lesspipe "$1" "$1.tar.${1##*.t}" ;;

	### Misc archives ###
	*.bz2|\
	*.gz|*.z|\
	*.zst|\
	*.lz|\
	*.lzma|*.xz)  ${DECOMPRESSOR} -- "$1" ;;
	*.rpm)        rpm -qpivl --changelog -- "$1" || rpm2tar -O "$1" | tar tvvf -;;
	*.cpi|*.cpio) cpio -itv < "$1" ;;
	*.ace)        unace l "$1" ;;
	*.arc)        arc v "$1" ;;
	*.arj)        arj l -- "$1" || unarj l "$1" ;;
	*.cab)        cabextract -l -- "$1" ;;
	*.lha|*.lzh)  lha v "$1" ;;
	*.zoo)        zoo -list "$1" || unzoo -l "$1" ;;
	*.7z|*.exe)   7z l -- "$1" || 7za l -- "$1" || 7zr l -- "$1" ;;
	*.a)          ar tv "$1" ;;
	*.elf)        readelf -a -W -- "$1" ;;
	*.so)         readelf -h -d -s -W -- "$1" ;;
	*.mo|*.gmo)   msgunfmt -- "$1" ;;

	*.rar|.r[0-9][0-9])  unrar l -- "$1" ;;

	*.jar|*.war|*.ear|*.xpi|*.zip)
		unzip -v "$1" || miniunzip -l "$1" || miniunz -l "$1" || zipinfo -v "$1"
		;;

	*.deb|*.udeb)
		if type -P dpkg > /dev/null ; then
			dpkg --info "$1"
			dpkg --contents "$1"
		else
			ar tv "$1"
			ar p "$1" data.tar.gz | tar tzvvf -
		fi
		;;

	### Filesystems ###
	*.squashfs)   unsquashfs -s "$1" && unsquashfs -ll "$1" ;;

	### Media ###
	*.bmp|*.gif|*.jpeg|*.jpg|*.ico|*.pcd|*.pcx|*.png|*.ppm|*.tga|*.tiff|*.tif|*.webp)
		identify -verbose -- "$1" || file -L -- "$1"
		;;
	*.asf|*.avi|*.flv|*.mkv|*.mov|*.mp4|*.mpeg|*.mpg|*.qt|*.ram|*.rm|*.webm|*.wmv)
		midentify "$1" || file -L -- "$1"
		;;
	*.mp3)        mp3info "$1" || id3info "$1" ;;
	*.ogg)        ogginfo "$1" ;;
	*.flac)       metaflac --list "$1" ;;
	*.torrent)    torrentinfo "$1" || torrentinfo-console "$1" || ctorrent -x "$1" ;;
	*.bin|*.cue|*.raw)
		# not all .bin/.raw files are cd images #285507
		# fall back to lesspipe_file if .cue doesn't exist, or if
		# cd-info failed to parse things sanely
		[[ -e ${1%.*}.cue ]] \
			&& cd-info --no-header --no-device-info "$1" \
			|| lesspipe_file "$1"
		;;
	*.iso)
		iso_info=$(isoinfo -d -i "$1")
		echo "${iso_info}"
		# Joliet output overrides Rock Ridge, so prefer the better Rock
		case ${iso_info} in
			*$'\n'"Rock Ridge"*) iso_opts="-R";;
			*$'\n'"Joliet"*)     iso_opts="-J";;
			*)                   iso_opts="";;
		esac
		isoinfo -l ${iso_opts} -i "$1"
		;;

	### Encryption stuff ###
	*.crl) crl_filter "$1" ;;
	*.csr) csr_filter "$1" ;;
	*.crt|*.pem) crt_filter "$1" ;;
	*.jks) jks_filter "$1" ;;
	*.p12|*.pfx) p12_filter "$1" ;;

# May not be such a good idea :)
#	### Device nodes ###
#	/dev/[hs]d[a-z]*)
#		fdisk -l "${1:0:8}"
#		[[ $1 == *hd* ]] && hdparm -I "${1:0:8}"
#		;;

	### Everything else ###
	*)
		case $(( recur++ )) in
			# Maybe we didn't match due to case issues ...
			0) lesspipe "$1" "$(echo "$1" | LC_ALL=C tr '[:upper:]' '[:lower:]')" ;;

			# Maybe we didn't match because the file is named weird ...
			1) lesspipe_file "$1" ;;
		esac

		# So no matches from above ... finally fall back to an external
		# coloring package.  No matching here so we don't have to worry
		# about keeping in sync with random packages.  Any coloring tool
		# you use should not output errors about unsupported files to
		# stdout.  If it does, it's your problem.

		# Allow people to flip color off if they dont want it
		case ${LESSCOLOR} in
			always)                   LESSCOLOR=2;;
			[yY][eE][sS]|[yY]|1|true) LESSCOLOR=1;;
			[nN][oO]|[nN]|0|false)    LESSCOLOR=0;;
			*)                        LESSCOLOR=1;;
		esac

		[[ -n ${NO_COLOR} ]] && LESSCOLOR=0

		if [[ ${LESSCOLOR} != "0" ]] && [[ -n ${LESSCOLORIZER=pygmentize -O style=rrt} ]] ; then
			# 2: Only colorize if user forces it ...
			# 1: ... or we know less will handle raw codes -- this will
			#    not detect -seiRM, so set LESSCOLORIZER yourself
			if [[ ${LESSCOLOR} == "2" ]] || [[ " ${LESS} " == *" -"[rR]" "* ]] ; then
				LESSQUIET=true ${LESSCOLORIZER} "$1"
			fi
		fi

		# Nothing left to do but let less deal
		exit 0
		;;
	esac
}

if [[ $# -eq 0 ]] ; then
	echo "Usage: lesspipe <file>"
elif [[ $1 == "-V" || $1 == "--version" ]] ; then
	cat <<-EOF
		lesspipe (git)
		Copyright 1999-2024 Gentoo Authors
		Mike Frysinger <vapier@gentoo.org>
		     (with plenty of ideas stolen from other projects/distros)

	EOF
	less -V
elif [[ $1 == "-h" || $1 == "--help" ]] ; then
	cat <<-EOF
		lesspipe: preprocess files before sending them to less

		Usage: lesspipe <file>

		lesspipe specific settings:
		  LESSCOLOR env     - toggle colorizing of output (no/yes/always; default: yes)
		  LESSCOLORIZER env - program used to colorize output (default: pygmentize)
		  LESSIGNORE        - list of extensions to ignore (don't do anything fancy)

		You can create per-user filters as well by creating the executable file:
		  ~/.lessfilter
		One argument is passed to it: the file to display.  The script should exit 0
		to indicate it handled the file, or non-zero to tell lesspipe to handle it.

		To use lesspipe, simply add to your environment:
		  export LESSOPEN="|lesspipe %s"

		For colorization, install dev-python/pygments for the pygmentize program. Note,
		if using alternative code2color from sys app-text/lesspipe you may run out of
		memory due to #188835.

		Run 'less --help' or 'man less' for more info.
	EOF
else
	recur=0
	[[ -z ${LESSDEBUG+set} ]] && exec 2>/dev/null
	lesspipe "$1"
fi
