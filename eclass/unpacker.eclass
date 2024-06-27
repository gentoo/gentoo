# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: unpacker.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: helpers for extraneous file formats and consistent behavior across EAPIs
# @DESCRIPTION:
# Some extraneous file formats are not part of PMS, or are only in certain
# EAPIs.  Rather than worrying about that, support the crazy cruft here
# and for all EAPI versions.

# Possible todos:
#  - merge rpm unpacking
#  - support partial unpacks?

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_UNPACKER_ECLASS} ]]; then
_UNPACKER_ECLASS=1

inherit multiprocessing toolchain-funcs

# @ECLASS_VARIABLE: UNPACKER_BZ2
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Utility to use to decompress bzip2 files.  Will dynamically pick between
# `lbzip2`, `pbzip2`, and `bzip2`.  Make sure your choice accepts the "-dc"
# options.
# Note: this is meant for users to set, not ebuilds.

# @ECLASS_VARIABLE: UNPACKER_LZIP
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Utility to use to decompress lzip files.  Will dynamically pick between
# `xz`, `plzip`, `pdlzip`, and `lzip`.  Make sure your choice accepts the "-dc" options.
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

	local iscompressed=$(file -S -b "${tmpfile}")
	if [[ ${iscompressed:0:8} == "compress" ]] ; then
		iscompressed=1
		mv "${tmpfile}"{,.Z}
		gunzip "${tmpfile}"
	else
		iscompressed=0
	fi
	local istar=$(file -S -b "${tmpfile}")
	if [[ ${istar:0:9} == "POSIX tar" ]] ; then
		istar=1
	else
		istar=0
	fi

	# For some reason gzip dies with this ... dd can't provide buffer fast enough ?
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
			2.1.4|2.1.5|2.1.6|2.2.0|2.3.0|2.4.0)
				skip=$(grep -a offset=.*head.*wc "${src}" | awk '{print $3}' | head -n 1)
				skip=$(head -n ${skip} "${src}" | wc -c)
				exe="dd"
				;;
			2.4.5)
				# e.g.: skip="713"
				skip=$(
					sed -n -e '/^skip=/{s:skip="\(.*\)":\1:p;q}' "${src}"
				)
				skip=$(head -n "${skip}" "${src}" | wc -c)
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
		*)		die "makeself can't handle exe '${exe}'"
	esac

	# lets grab the first few bytes of the file to figure out what kind of archive it is
	local decomp= filetype suffix
	filetype=$("${exe[@]}" 2>/dev/null | head -c 512 | file -S -b -) || die
	case ${filetype} in
		*tar\ archive*)
			decomp=cat
			;;
		bzip2*)
			suffix=bz2
			;;
		gzip*)
			suffix=gz
			;;
		compress*)
			suffix=z
			;;
		XZ*)
			suffix=xz
			;;
		Zstandard*)
			suffix=zst
			;;
		lzop*)
			suffix=lzo
			;;
		LZ4*)
			suffix=lz4
			;;
		"ASCII text"*)
			decomp='base64 -d'
			;;
		*)
			die "Unknown filetype \"${filetype}\", for makeself ${src##*/} ('${ver}' +${skip})"
			;;
	esac

	[[ -z ${decomp} ]] && decomp=$(_unpacker_get_decompressor ".${suffix}")
	"${exe[@]}" | ${decomp} | tar --no-same-owner -xf -
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

	{
		# on AIX ar doesn't work out as their ar used a different format
		# from what GNU ar (and thus what .deb files) produce
		if [[ -n ${EPREFIX} ]] ; then
			{
				read # global header
				[[ ${REPLY} = "!<arch>" ]] || die "${deb} does not seem to be a deb archive"
				local f timestamp uid gid mode size magic
				while read f timestamp uid gid mode size magic ; do
					[[ -n ${f} && -n ${size} ]] || continue # ignore empty lines
					# GNU ar uses / as filename terminator (and .deb permits that)
					f=${f%/}
					if [[ ${f} = "data.tar"* ]] ; then
						local decomp=$(_unpacker_get_decompressor "${f}")
						head -c "${size}" | ${decomp:-cat}
						assert "unpacking ${f} from ${deb} failed"
						break
					else
						head -c "${size}" > /dev/null # trash it
					fi
				done
			} < "${deb}"
		else
			local f=$(
				$(tc-getBUILD_AR) t "${deb}" | grep ^data.tar
				assert "data not found in ${deb}"
			)
			local decomp=$(_unpacker_get_decompressor "${f}")
			$(tc-getBUILD_AR) p "${deb}" "${f}" | ${decomp:-cat}
			assert "unpacking ${f} from ${deb} failed"
		fi
	} | tar --no-same-owner -xf -
	assert "unpacking ${deb} failed"
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

# @FUNCTION: unpack_7z
# @USAGE: <7z file>
# @DESCRIPTION:
# Unpack 7z archives.
unpack_7z() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local p7z=$(find_unpackable_file "$1")
	unpack_banner "${p7z}"

	# warning: putting local and command substitution in a single call
	# discards the exit status!
	local output
	output="$(7z x -y "${p7z}")"
	if [ $? -ne 0 ]; then
		echo "${output}" >&2
		die "unpacking ${p7z} failed (arch=unpack_7z)"
	fi
}

# @FUNCTION: unpack_rar
# @USAGE: <rar file>
# @DESCRIPTION:
# Unpack RAR archives.
unpack_rar() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local rar=$(find_unpackable_file "$1")
	unpack_banner "${rar}"
	unrar x -idq -o+ "${rar}" || die "unpacking ${rar} failed (arch=unpack_rar)"
}

# @FUNCTION: unpack_lha
# @USAGE: <lha file>
# @DESCRIPTION:
# Unpack LHA/LZH archives.
unpack_lha() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local lha=$(find_unpackable_file "$1")
	unpack_banner "${lha}"
	lha xfq "${lha}" || die "unpacking ${lha} failed (arch=unpack_lha)"
}

# @FUNCTION: _unpacker_get_decompressor
# @INTERNAL
# @USAGE: <filename>
# @DESCRIPTION:
# Get decompressor command for specified filename.
_unpacker_get_decompressor() {
	case ${1} in
	*.bz2|*.tbz|*.tbz2)
		local bzcmd=${PORTAGE_BZIP2_COMMAND:-$(
			type -P lbzip2 || type -P pbzip2 || type -P bzip2
		)}
		local bzuncmd=${PORTAGE_BUNZIP2_COMMAND:-${bzcmd} -d}
		: "${UNPACKER_BZ2:=${bzuncmd}}"
		echo "${UNPACKER_BZ2} -c"
		;;
	*.z|*.gz|*.tgz)
		echo "gzip -dc" ;;
	*.lzma|*.xz|*.txz)
		echo "xz -T$(makeopts_jobs) -dc" ;;
	*.lz)
		find_lz_unpacker() {
			if has_version -b ">=app-arch/xz-utils-5.4.0" ; then
				echo xz
				return
			fi

			local x
			for x in plzip pdlzip lzip ; do
				type -P ${x} && break
			done
		}

		: "${UNPACKER_LZIP:=$(find_lz_unpacker)}"
		echo "${UNPACKER_LZIP} -dc" ;;
	*.zst)
		echo "zstd -dc" ;;
	*.lz4)
		echo "lz4 -dc" ;;
	*.lzo)
		echo "lzop -dc" ;;
	esac
}

# @FUNCTION: unpack_gpkg
# @USAGE: <gpkg file>
# @DESCRIPTION:
# Unpack the image subarchive of a GPKG package on-the-fly, preserving
# the original directory structure (i.e. into <gpkg-dir>/image).
unpack_gpkg() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local gpkg=$(find_unpackable_file "$1")
	unpack_banner "${gpkg}"

	local l images=()
	while read -r l; do
		case ${l} in
			*/image.tar*.sig)
				;;
			*/image.tar*)
				images+=( "${l}" )
				;;
		esac
	done < <(tar -tf "${gpkg}" || die "unable to list ${gpkg}")

	if [[ ${#images[@]} -eq 0 ]]; then
		die "No image.tar found in ${gpkg}"
	elif [[ ${#images[@]} -gt 1 ]]; then
		die "More than one image.tar found in ${gpkg}"
	fi

	local decomp=$(_unpacker_get_decompressor "${images[0]}")
	local dirname=${images[0]%/*}
	mkdir -p "${dirname}" || die
	tar -xOf "${gpkg}" "${images[0]}" | ${decomp:-cat} |
		tar --no-same-owner -C "${dirname}" -xf -
	assert "Unpacking ${gpkg} failed"
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
	local m=${a,,}
	a=$(find_unpackable_file "${a}")

	# first figure out the decompression method
	local comp=$(_unpacker_get_decompressor "${m}")

	# then figure out if there are any archiving aspects
	local arch=""
	case ${m} in
	*.gpkg.tar)
		arch="unpack_gpkg" ;;
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

	# 7z, rar and lha/lzh are handled by package manager in EAPI < 8
	if [[ ${EAPI} != 7 ]]; then
		case ${m} in
		*.7z)
			arch="unpack_7z" ;;
		*.rar)
			arch="unpack_rar" ;;
		*.lha|*.lzh)
			arch="unpack_lha" ;;
		esac
	fi

	# finally do the unpack
	if [[ -z ${arch}${comp} ]] ; then
		unpack "$1"
		return $?
	fi

	[[ ${arch} != unpack_* ]] && unpack_banner "${a}"

	if [[ -z ${arch} ]] ; then
		# Need to decompress the file into $PWD #408801
		local _a=${a%.*}
		${comp} < "${a}" > "${_a##*/}"
	elif [[ -z ${comp} ]] ; then
		${arch} "${a}"
	else
		${comp} < "${a}" | ${arch} -
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
	local uri
	local -A deps

	if [[ $# -eq 0 ]] ; then
		# Disable path expansion for USE conditionals. #654960
		set -f
		set -- ${SRC_URI}
		set +f
	fi

	for uri in "$@" ; do
		case ${uri,,} in
		*.cpio.*|*.cpio)
			deps[cpio]="app-alternatives/cpio" ;;
		*.rar)
			deps[rar]="app-arch/unrar" ;;
		*.7z)
			deps[7z]="app-arch/p7zip" ;;
		*.xz)
			deps[xz]="app-arch/xz-utils" ;;
		*.zip)
			deps[zip]="app-arch/unzip" ;;
		*.lz)
			deps[lz]="
				|| (
					>=app-arch/xz-utils-5.4.0
					app-arch/plzip
					app-arch/pdlzip
					app-arch/lzip
				)
			"
			;;
		*.zst)
			deps[zst]="app-arch/zstd" ;;
		*.lha|*.lzh)
			deps[lhah]="app-arch/lha" ;;
		*.lz4)
			deps[lz4]="app-arch/lz4" ;;
		*.lzo)
			deps[lzo]="app-arch/lzop" ;;
		esac
	done

	echo "${deps[*]}"
}

fi

EXPORT_FUNCTIONS src_unpack
