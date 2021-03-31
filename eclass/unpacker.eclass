# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: unpacker.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: helpers for extraneous file formats and consistent behavior across EAPIs
# @DESCRIPTION:
# Some extraneous file formats are not part of PMS, or are only in certain
# EAPIs.  Rather than worrying about that, support the crazy cruft here
# and for all EAPI versions.

# Possible todos:
#  - merge rpm unpacking
#  - support partial unpacks?

if [[ -z ${_UNPACKER_ECLASS} ]]; then
_UNPACKER_ECLASS=1

inherit toolchain-funcs

# @ECLASS-VARIABLE: UNPACKER_BZ2
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Utility to use to decompress bzip2 files.  Will dynamically pick between
# `pbzip2` and `bzip2`.  Make sure your choice accepts the "-dc" options.
# Note: this is meant for users to set, not ebuilds.

# @ECLASS-VARIABLE: UNPACKER_LZIP
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Utility to use to decompress lzip files.  Will dynamically pick between
# `plzip`, `pdlzip` and `lzip`.  Make sure your choice accepts the "-dc" options.
# Note: this is meant for users to set, not ebuilds.

# for internal use only (unpack_pdv and unpack_makeself)
find_unpackable_file() {
	local src=$1
	if [[ -z ${src} ]] ; then
		src=${DISTDIR}/${A}
	else
		if [[ ${src} == ./* ]] ; then
			: # already what we want
		elif [[ -e ${DISTDIR}/${src} ]] ; then
			src=${DISTDIR}/${src}
		elif [[ -e ${PWD}/${src} ]] ; then
			src=${PWD}/${src}
		elif [[ -e ${src} ]] ; then
			src=${src}
		fi
	fi
	[[ ! -e ${src} ]] && return 1
	echo "${src}"
}

unpack_banner() {
	echo ">>> Unpacking ${1##*/} to ${PWD}"
}

# @FUNCTION: unpack_pdv
# @USAGE: <file to unpack> <size of off_t>
# @DESCRIPTION:
# Unpack those pesky pdv generated files ...
# They're self-unpacking programs with the binary package stuffed in
# the middle of the archive.  Valve seems to use it a lot ... too bad
# it seems to like to segfault a lot :(.  So lets take it apart ourselves.
#
# You have to specify the off_t size ... I have no idea how to extract that
# information out of the binary executable myself.  Basically you pass in
# the size of the off_t type (in bytes) on the machine that built the pdv
# archive.
#
# One way to determine this is by running the following commands:
#
# @CODE
# 	strings <pdv archive> | grep lseek
# 	strace -elseek <pdv archive>
# @CODE
#
# Basically look for the first lseek command (we do the strings/grep because
# sometimes the function call is _llseek or something) and steal the 2nd
# parameter.  Here is an example:
#
# @CODE
# 	$ strings hldsupdatetool.bin | grep lseek
# 	lseek
# 	$ strace -elseek ./hldsupdatetool.bin
# 	lseek(3, -4, SEEK_END)					= 2981250
# @CODE
#
# Thus we would pass in the value of '4' as the second parameter.
unpack_pdv() {
	local src=$(find_unpackable_file "$1")
	local sizeoff_t=$2

	[[ -z ${src} ]] && die "Could not locate source for '$1'"
	[[ -z ${sizeoff_t} ]] && die "No idea what off_t size was used for this pdv :("

	unpack_banner "${src}"

	local metaskip=$(tail -c ${sizeoff_t} "${src}" | hexdump -e \"%i\")
	local tailskip=$(tail -c $((${sizeoff_t}*2)) "${src}" | head -c ${sizeoff_t} | hexdump -e \"%i\")

	# grab metadata for debug reasons
	local metafile="${T}/${FUNCNAME}.meta"
	tail -c +$((${metaskip}+1)) "${src}" > "${metafile}"

	# rip out the final file name from the metadata
	local datafile=$(tail -c +$((${metaskip}+1)) "${src}" | strings | head -n 1)
	datafile=$(basename "${datafile}")

	# now lets uncompress/untar the file if need be
	local tmpfile="${T}/${FUNCNAME}"
	tail -c +$((${tailskip}+1)) ${src} 2>/dev/null | head -c 512 > "${tmpfile}"

	local iscompressed=$(file -b "${tmpfile}")
	if [[ ${iscompressed:0:8} == "compress" ]] ; then
		iscompressed=1
		mv "${tmpfile}"{,.Z}
		gunzip "${tmpfile}"
	else
		iscompressed=0
	fi
	local istar=$(file -b "${tmpfile}")
	if [[ ${istar:0:9} == "POSIX tar" ]] ; then
		istar=1
	else
		istar=0
	fi

	#for some reason gzip dies with this ... dd cant provide buffer fast enough ?
	#dd if=${src} ibs=${metaskip} count=1 \
	#	| dd ibs=${tailskip} skip=1 \
	#	| gzip -dc \
	#	> ${datafile}
	if [ ${iscompressed} -eq 1 ] ; then
		if [ ${istar} -eq 1 ] ; then
			tail -c +$((${tailskip}+1)) "${src}" 2>/dev/null \
				| head -c $((${metaskip}-${tailskip})) \
				| tar -xzf -
		else
			tail -c +$((${tailskip}+1)) "${src}" 2>/dev/null \
				| head -c $((${metaskip}-${tailskip})) \
				| gzip -dc \
				> ${datafile}
		fi
	else
		if [ ${istar} -eq 1 ] ; then
			tail -c +$((${tailskip}+1)) "${src}" 2>/dev/null \
				| head -c $((${metaskip}-${tailskip})) \
				| tar --no-same-owner -xf -
		else
			tail -c +$((${tailskip}+1)) "${src}" 2>/dev/null \
				| head -c $((${metaskip}-${tailskip})) \
				> ${datafile}
		fi
	fi
	true
	#[ -s "${datafile}" ] || die "failure unpacking pdv ('${metaskip}' '${tailskip}' '${datafile}')"
	#assert "failure unpacking pdv ('${metaskip}' '${tailskip}' '${datafile}')"
}

# @FUNCTION: unpack_makeself
# @USAGE: [file to unpack] [offset] [tail|dd]
# @DESCRIPTION:
# Unpack those pesky makeself generated files ...
# They're shell scripts with the binary package tagged onto
# the end of the archive.  Loki utilized the format as does
# many other game companies.
#
# If the file is not specified, then ${A} is used.  If the
# offset is not specified then we will attempt to extract
# the proper offset from the script itself.
unpack_makeself() {
	local src_input=${1:-${A}}
	local src=$(find_unpackable_file "${src_input}")
	local skip=$2
	local exe=$3

	[[ -z ${src} ]] && die "Could not locate source for '${src_input}'"

	unpack_banner "${src}"

	if [[ -z ${skip} ]] ; then
		local ver=$(grep -m1 -a '#.*Makeself' "${src}" | awk '{print $NF}')
		local skip=0
		exe=tail
		case ${ver} in
			1.5.*|1.6.0-nv*)	# tested 1.5.{3,4,5} ... guessing 1.5.x series is same
				skip=$(grep -a ^skip= "${src}" | cut -d= -f2)
				;;
			2.0|2.0.1)
				skip=$(grep -a ^$'\t'tail "${src}" | awk '{print $2}' | cut -b2-)
				;;
			2.1.1)
				skip=$(grep -a ^offset= "${src}" | awk '{print $2}' | cut -b2-)
				(( skip++ ))
				;;
			2.1.2)
				skip=$(grep -a ^offset= "${src}" | awk '{print $3}' | head -n 1)
				(( skip++ ))
				;;
			2.1.3)
				skip=`grep -a ^offset= "${src}" | awk '{print $3}'`
				(( skip++ ))
				;;
			2.1.4|2.1.5|2.1.6|2.2.0|2.4.0)
				skip=$(grep -a offset=.*head.*wc "${src}" | awk '{print $3}' | head -n 1)
				skip=$(head -n ${skip} "${src}" | wc -c)
				exe="dd"
				;;
			*)
				eerror "I'm sorry, but I was unable to support the Makeself file."
				eerror "The version I detected was '${ver}'."
				eerror "Please file a bug about the file ${src##*/} at"
				eerror "https://bugs.gentoo.org/ so that support can be added."
				die "makeself version '${ver}' not supported"
				;;
		esac
		debug-print "Detected Makeself version ${ver} ... using ${skip} as offset"
	fi
	case ${exe} in
		tail)	exe=( tail -n +${skip} "${src}" );;
		dd)		exe=( dd ibs=${skip} skip=1 if="${src}" );;
		*)		die "makeself cant handle exe '${exe}'"
	esac

	# lets grab the first few bytes of the file to figure out what kind of archive it is
	local filetype tmpfile="${T}/${FUNCNAME}"
	"${exe[@]}" 2>/dev/null | head -c 512 > "${tmpfile}"
	filetype=$(file -b "${tmpfile}") || die
	case ${filetype} in
		*tar\ archive*)
			"${exe[@]}" | tar --no-same-owner -xf -
			;;
		bzip2*)
			"${exe[@]}" | bzip2 -dc | tar --no-same-owner -xf -
			;;
		gzip*)
			"${exe[@]}" | tar --no-same-owner -xzf -
			;;
		compress*)
			"${exe[@]}" | gunzip | tar --no-same-owner -xf -
			;;
		XZ*)
			"${exe[@]}" | unxz | tar --no-same-owner -xf -
			;;
		*)
			eerror "Unknown filetype \"${filetype}\" ?"
			false
			;;
	esac
	assert "failure unpacking (${filetype}) makeself ${src##*/} ('${ver}' +${skip})"
}

# @FUNCTION: unpack_deb
# @USAGE: <one deb to unpack>
# @DESCRIPTION:
# Unpack a Debian .deb archive in style.
unpack_deb() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local deb=$(find_unpackable_file "$1")

	unpack_banner "${deb}"

	# on AIX ar doesn't work out as their ar used a different format
	# from what GNU ar (and thus what .deb files) produce
	if [[ -n ${EPREFIX} ]] ; then
		{
			read # global header
			[[ ${REPLY} = "!<arch>" ]] || die "${deb} does not seem to be a deb archive"
			local f timestamp uid gid mode size magic
			while read f timestamp uid gid mode size magic ; do
				[[ -n ${f} && -n ${size} ]] || continue # ignore empty lines
				if [[ ${f} = "data.tar"* ]] ; then
					head -c "${size}" > "${f}"
				else
					head -c "${size}" > /dev/null # trash it
				fi
			done
		} < "${deb}"
	else
		$(tc-getBUILD_AR) x "${deb}" || die
	fi

	unpacker ./data.tar*

	# Clean things up #458658.  No one seems to actually care about
	# these, so wait until someone requests to do something else ...
	rm -f debian-binary {control,data}.tar*
}

# @FUNCTION: unpack_cpio
# @USAGE: <one cpio to unpack>
# @DESCRIPTION:
# Unpack a cpio archive, file "-" means stdin.
unpack_cpio() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	# needed as cpio always reads from stdin
	local cpio_cmd=( cpio --make-directories --extract --preserve-modification-time )
	if [[ $1 == "-" ]] ; then
		unpack_banner "stdin"
		"${cpio_cmd[@]}"
	else
		local cpio=$(find_unpackable_file "$1")
		unpack_banner "${cpio}"
		"${cpio_cmd[@]}" <"${cpio}"
	fi
}

# @FUNCTION: unpack_zip
# @USAGE: <zip file>
# @DESCRIPTION:
# Unpack zip archives.
# This function ignores all non-fatal errors (i.e. warnings).
# That is useful for zip archives with extra crap attached
# (e.g. self-extracting archives).
unpack_zip() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local zip=$(find_unpackable_file "$1")
	unpack_banner "${zip}"
	unzip -qo "${zip}"

	[[ $? -le 1 ]] || die "unpacking ${zip} failed (arch=unpack_zip)"
}

# @FUNCTION: _unpacker
# @USAGE: <one archive to unpack>
# @INTERNAL
# @DESCRIPTION:
# Unpack the specified archive.  We only operate on one archive here
# to keep down on the looping logic (that is handled by `unpacker`).
_unpacker() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local a=$1
	local m=$(echo "${a}" | tr '[:upper:]' '[:lower:]')
	a=$(find_unpackable_file "${a}")

	# first figure out the decompression method
	local comp=""
	case ${m} in
	*.bz2|*.tbz|*.tbz2)
		local bzcmd=${PORTAGE_BZIP2_COMMAND:-$(type -P pbzip2 || type -P bzip2)}
		local bzuncmd=${PORTAGE_BUNZIP2_COMMAND:-${bzcmd} -d}
		: ${UNPACKER_BZ2:=${bzuncmd}}
		comp="${UNPACKER_BZ2} -c"
		;;
	*.z|*.gz|*.tgz)
		comp="gzip -dc" ;;
	*.lzma|*.xz|*.txz)
		comp="xz -dc" ;;
	*.lz)
		: ${UNPACKER_LZIP:=$(type -P plzip || type -P pdlzip || type -P lzip)}
		comp="${UNPACKER_LZIP} -dc" ;;
	*.zst)
		comp="zstd -dfc" ;;
	esac

	# then figure out if there are any archiving aspects
	local arch=""
	case ${m} in
	*.tgz|*.tbz|*.tbz2|*.txz|*.tar.*|*.tar)
		arch="tar --no-same-owner -xof" ;;
	*.cpio.*|*.cpio)
		arch="unpack_cpio" ;;
	*.deb)
		arch="unpack_deb" ;;
	*.run)
		arch="unpack_makeself" ;;
	*.sh)
		# Not all shell scripts are makeself
		if head -n 30 "${a}" | grep -qs '#.*Makeself' ; then
			arch="unpack_makeself"
		fi
		;;
	*.bin)
		# Makeself archives can be annoyingly named
		if head -c 100 "${a}" | grep -qs '#.*Makeself' ; then
			arch="unpack_makeself"
		fi
		;;
	*.zip)
		arch="unpack_zip" ;;
	esac

	# finally do the unpack
	if [[ -z ${arch}${comp} ]] ; then
		unpack "$1"
		return $?
	fi

	[[ ${arch} != unpack_* ]] && unpack_banner "${a}"

	if [[ -z ${arch} ]] ; then
		# Need to decompress the file into $PWD #408801
		local _a=${a%.*}
		${comp} "${a}" > "${_a##*/}"
	elif [[ -z ${comp} ]] ; then
		${arch} "${a}"
	else
		${comp} "${a}" | ${arch} -
	fi

	assert "unpacking ${a} failed (comp=${comp} arch=${arch})"
}

# @FUNCTION: unpacker
# @USAGE: [archives to unpack]
# @DESCRIPTION:
# This works in the same way that `unpack` does.  If you don't specify
# any files, it will default to ${A}.
unpacker() {
	local a
	[[ $# -eq 0 ]] && set -- ${A}
	for a ; do _unpacker "${a}" ; done
}

# @FUNCTION: unpacker_src_unpack
# @DESCRIPTION:
# Run `unpacker` to unpack all our stuff.
unpacker_src_unpack() {
	unpacker
}

# @FUNCTION: unpacker_src_uri_depends
# @USAGE: [archives that we will unpack]
# @RETURN: Dependencies needed to unpack all the archives
# @DESCRIPTION:
# Walk all the specified files (defaults to $SRC_URI) and figure out the
# dependencies that are needed to unpack things.
#
# Note: USE flags are not yet handled.
unpacker_src_uri_depends() {
	local uri deps d

	if [[ $# -eq 0 ]] ; then
		# Disable path expansion for USE conditionals. #654960
		set -f
		set -- ${SRC_URI}
		set +f
	fi

	for uri in "$@" ; do
		case ${uri} in
		*.cpio.*|*.cpio)
			d="app-arch/cpio" ;;
		*.deb)
			# platforms like AIX don't have a good ar
			d="kernel_AIX? ( app-arch/deb2targz )" ;;
		*.rar|*.RAR)
			d="app-arch/unrar" ;;
		*.7z)
			d="app-arch/p7zip" ;;
		*.xz)
			d="app-arch/xz-utils" ;;
		*.zip)
			d="app-arch/unzip" ;;
		*.lz)
			d="|| ( app-arch/plzip app-arch/pdlzip app-arch/lzip )" ;;
		*.zst)
			d="app-arch/zstd" ;;
		esac
		deps+=" ${d}"
	done

	echo "${deps}"
}

EXPORT_FUNCTIONS src_unpack

fi
