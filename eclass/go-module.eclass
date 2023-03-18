# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-module.eclass
# @MAINTAINER:
# William Hubbs <williamh@gentoo.org>
# @AUTHOR:
# William Hubbs <williamh@gentoo.org>
# Robin H. Johnson <robbat2@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: basic eclass for building software written as go modules
# @DESCRIPTION:
# This eclass provides basic settings and functions needed by all software
# written in the go programming language that uses modules.
# If the software you are packaging has a file named go.mod in its top level
# directory, it uses modules.
# 
# Modules have been the preferred method of tracking dependencies in software
# written in Go since version 1.16,
# so if the software isn't using modules, it should be updated.
#
# Also, if the top level go.mod file contains a go directive that
# specifies a version of go prior to 1.14, this should be reported
# upstream and updated.
#
# If the software has a directory named vendor in its
# top level directory, the only thing you need to do is inherit the
# eclass. If it doesn't, you need to also create a dependency tarball and
# host it somewhere, for example in your dev space. It's recommended that
# a format supporting parallel decompression is used and developers should
# use higher levels of compression like '-9' for xz.
#
# Here is an example of how to create a dependency tarball.
# The base directory in the GOMODCACHE setting must be go-mod in order
# to match the settings in this eclass.
#
# @CODE
#
# $ cd /path/to/project
# $ GOMODCACHE="${PWD}"/go-mod go mod download -modcacherw
# $ XZ_OPT='-T0 -9' tar -acf project-1.0-deps.tar.xz go-mod
#
# @CODE
#
# Since Go programs are statically linked, it is important that your ebuild's
# LICENSE= setting includes the licenses of all statically linked
# dependencies. So please make sure it is accurate.
# You can use a utility like dev-go/golicense (network connectivity is
# required) to extract this information from the compiled binary.
#
# @EXAMPLE:
#
# @CODE
#
# inherit go-module
#
# SRC_URI="https://github.com/example/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# Add this line if you have a dependency tarball.
# SRC_URI+=" ${P}-deps.tar.xz"
#
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GO_MODULE_ECLASS} ]]; then
_GO_MODULE_ECLASS=1

inherit multiprocessing toolchain-funcs

if [[ ! ${GO_OPTIONAL} ]]; then
	BDEPEND=">=dev-lang/go-1.18"

	# Workaround for pkgcheck false positive: https://github.com/pkgcore/pkgcheck/issues/214
	# MissingUnpackerDep: version ...: missing BDEPEND="app-arch/unzip"
	# Added here rather than to each affected package, so it can be cleaned up just
	# once when pkgcheck is improved.
	BDEPEND+=" app-arch/unzip"
fi

# Force go to build in module mode.
# In this mode the GOPATH environment variable is ignored.
# this will become the default in the future.
export GO111MODULE=on

# Set the default for the go build cache
# See "go help environment" for information on this setting
export GOCACHE="${T}/go-build"

# Set the default for the go module cache
# See "go help environment" for information on this setting
export GOMODCACHE="${WORKDIR}/go-mod"

# The following go flags should be used for all builds.
# -buildmode=pie builds position independent executables
# -buildvcs=false omits version control information
# -modcacherw makes the build cache read/write
# -v prints the names of packages as they are compiled
# -x prints commands as they are executed
export GOFLAGS="-buildvcs=false -modcacherw -v -x"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

# Go packages should not be stripped with strip(1).
RESTRICT+=" strip"

# @ECLASS_VARIABLE: EGO_SUM
# @DEPRECATED: none
# @DESCRIPTION:
# This is replaced by a dependency tarball, see above for how to create
# one.
#
# This array is based on the contents of the go.sum file from the top
# level directory of the software you are packaging. Each entry must be
# quoted and contain the first two fields of a line from go.sum.
#
# You can use some combination of sed/awk/cut to extract the
# contents of EGO_SUM or use the dev-go/get-ego-vendor tool.
# 
# One manual way to do this is the following:
#
# @CODE
#
# cat go.sum | cut -d" " -f1,2 | awk '{print "\t\"" $0 "\""}'
# 
# @CODE
#
# The format of go.sum is described upstream here:
# https://go.dev/ref/mod#go-sum-files
#
# For inclusion in EGO_SUM, the h1: value and other future extensions SHOULD be
# omitted at this time. The EGO_SUM parser will accept them for ease of ebuild
# creation.
#
# h1:<hash> is the Hash1 structure used by upstream Go
# The Hash1 is MORE stable than Gentoo distfile hashing, and upstream warns
# that it's conceptually possible for the Hash1 value to remain stable while
# the upstream zipfiles change. Here are examples that do NOT change the h1:
# hash, but do change a regular checksum over all bytes of the file:
# - Differing mtimes within zipfile
# - Differing filename ordering with the zipfile
# - Differing zipfile compression parameters
# - Differing zipfile extra fields
#
# For Gentoo usage, the authors of this eclass feel that the h1: hash should
# NOT be included in the EGO_SUM at this time in order to reduce size of the
# ebuilds. This position will be reconsidered in future when a Go module
# distfile collision comes to light, where the Hash1 value of two distfiles is
# the same, but checksums over the file as a byte stream consider the files to
# be different.
#
# This decision  does NOT weaken Go module security, as Go will verify the
# go.sum copy of the Hash1 values during building of the package.

# @ECLASS_VARIABLE: _GOMODULE_GOPROXY_BASEURI
# @DEPRECATED: none
# @DESCRIPTION:
# Golang module proxy service to fetch module files from. Note that the module
# proxy generally verifies modules via the Hash1 code.
#
# Users in China may find some mirrors in the default list blocked, and should
# explicitly set an entry in /etc/portage/mirrors for goproxy to
# https://goproxy.cn/ or another mirror that is not blocked in China.
# See https://arslan.io/2019/08/02/why-you-should-use-a-go-module-proxy/ for
# further details
#
# This variable is NOT intended for user-level configuration of mirrors, but
# rather to cover go modules that might exist only on specific Goproxy
# servers for non-technical reasons.
#
# This variable should NOT be present in user-level configuration e.g.
# /etc/portage/make.conf, as it will violate metadata immutability!
#
# I am considering removing this and just hard coding mirror://goproxy
# below, so please do not rely on it.
: "${_GOMODULE_GOPROXY_BASEURI:=mirror://goproxy/}"

# @ECLASS_VARIABLE: _GOMODULE_GOSUM_REVERSE_MAP
# @DEPRECATED: none
# @DESCRIPTION:
# Mapping back from Gentoo distfile name to upstream distfile path.
# Associative array to avoid O(N*M) performance when populating the GOPROXY
# directory structure.
declare -A -g _GOMODULE_GOSUM_REVERSE_MAP

# @ECLASS_VARIABLE: GO_OPTIONAL
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-null value before inherit, the Go part of the
# ebuild will be considered optional. No dependencies will be added and
# no phase functions will be exported. You will need to set BDEPEND and
# call go-module_src_unpack in your ebuild.

# @FUNCTION: ego
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call go, passing the supplied arguments.
# This function dies if go fails. It also supports being called via 'nonfatal'.
# If you need to call go directly in your ebuilds, this is the way it
# should be done.
ego() {
	set -- go "$@"
	echo "$@" >&2
	"$@" || die -n "${*} failed"
}

# @FUNCTION: go-module_set_globals
# @DEPRECATED: none
# @DESCRIPTION:
# Convert the information in EGO_SUM for other usage in the ebuild.
# - Populates EGO_SUM_SRC_URI that can be added to SRC_URI
# - Exports _GOMODULE_GOSUM_REVERSE_MAP which provides reverse mapping from
#   distfile back to the relative part of SRC_URI, as needed for
#   GOPROXY=file:///...
go-module_set_globals() {
	local line exts
	# for tracking go.sum errors
	local error_in_gosum=0
	local -a gosum_errorlines
	# used make SRC_URI easier to read
	local newline=$'\n'

	# Now parse EGO_SUM
	for line in "${EGO_SUM[@]}"; do
		local module version modfile version_modfile kvs x
		read -r module version_modfile kvs <<< "${line}"
		# kvs contains the hash and may contain other data from
		# upstream in the future. We do not currently use any of this data.

		# Split 'v0.3.0/go.mod' into 'v0.3.0' and '/go.mod'
		# It might NOT have the trailing /go.mod
		IFS=/ read -r version modfile x <<<"${version_modfile}"
		# Reject multiple slashes
		if [[ -n ${x} ]]; then
			error_in_gosum=1
			gosum_errorlines+=( "Bad version: ${version_modfile}" )
			continue
		fi

		# The modfile variable should be either empty or '/go.mod'
		# There is a chance that upstream Go might add something else here in
		# the future, and we should be prepared to capture it.
		# The .info files do not need to be downloaded, they will be created
		# based on the .mod file.
		# See https://github.com/golang/go/issues/35922#issuecomment-584824275
		exts=()
		local errormsg=''
		case "${modfile}" in
			'') exts=( zip ) ;;
			'go.mod'|'/go.mod') exts=( mod ) ;;
			*) errormsg="Unknown modfile: line='${line}', modfile='${modfile}'" ;;
		esac

		# If it was a bad entry, restart the loop
		if [[ -n ${errormsg} ]]; then
			error_in_gosum=1
			gosum_errorlines+=( "${errormsg} line='${line}', modfile='${modfile}'" )
			continue
		fi

		_dir=$(_go-module_gomod_encode "${module}")

		for _ext in "${exts[@]}" ; do
			# Relative URI within a GOPROXY for a file
			_reluri="${_dir}/@v/${version}.${_ext}"
			# SRC_URI: LHS entry
			_uri="${_GOMODULE_GOPROXY_BASEURI}/${_reluri}"
#			_uri="mirror://goproxy/${_reluri}"
			# SRC_URI: RHS entry, encode any slash in the path as
			# %2F in the filename
			_distfile="${_reluri//\//%2F}"

			EGO_SUM_SRC_URI+=" ${_uri} -> ${_distfile}${newline}"
			_GOMODULE_GOSUM_REVERSE_MAP["${_distfile}"]="${_reluri}"
		done
	done

	if [[ ${error_in_gosum} != 0 ]]; then
		eerror "Trailing information in EGO_SUM in ${P}.ebuild"
		for line in "${gosum_errorlines[@]}" ; do
			eerror "${line}"
		done
		die "Invalid EGO_SUM format"
	fi

	# Ensure these variables are not changed past this point
	readonly EGO_SUM
	readonly EGO_SUM_SRC_URI
	readonly _GOMODULE_GOSUM_REVERSE_MAP

	# export the GOPROXY setting
	export GOPROXY="file://${T}/go-proxy"

	# Set the guard that we are safe
	_GO_MODULE_SET_GLOBALS_CALLED=1
}

# @FUNCTION: go-module_setup_proxy
# @DEPRECATED: none
# @DESCRIPTION:
# If your ebuild redefines src_unpack and uses EGO_SUM you need to call
# this function in src_unpack.
# It sets up the go module proxy in the appropriate location.
go-module_setup_proxy() {
	# shellcheck disable=SC2120
	debug-print-function "${FUNCNAME}" "$@"

	if [[ ! ${_GO_MODULE_SET_GLOBALS_CALLED} ]]; then
		die "go-module_set_globals must be called in global scope"
	fi

	local goproxy_dir="${GOPROXY/file:\/\//}"
	mkdir -p "${goproxy_dir}" || die

	# For each Golang module distfile, look up where it's supposed to go and
	# symlink it into place.
	local f
	local goproxy_mod_dir
	for f in ${A}; do
		goproxy_mod_path="${_GOMODULE_GOSUM_REVERSE_MAP["${f}"]}"
		if [[ -n "${goproxy_mod_path}" ]]; then
			debug-print-function "Populating go proxy for ${goproxy_mod_path}"
			# Build symlink hierarchy
			goproxy_mod_dir=$( dirname "${goproxy_dir}"/"${goproxy_mod_path}" )
			mkdir -p "${goproxy_mod_dir}" || die
			ln -sf "${DISTDIR}"/"${f}" "${goproxy_dir}/${goproxy_mod_path}" ||
				die "Failed to ln"
			local v=${goproxy_mod_path}
			v="${v%.mod}"
			v="${v%.zip}"
			v="${v//*\/}"
			_go-module_gosum_synthesize_files "${goproxy_mod_dir}" "${v}"
		fi
	done

	# Validate the gosum now
	_go-module_src_unpack_verify_gosum
}

# @FUNCTION: go-module_src_unpack
# @DESCRIPTION:
# If EGO_SUM is set, unpack the base tarball(s) and set up the
#   local go proxy. Also warn that this usage is deprecated.
# - Otherwise, if EGO_VENDOR is set, bail out.
# - Otherwise do a normal unpack.
go-module_src_unpack() {
	if use amd64 || use arm || use arm64 ||
		( use ppc64 && [[ $(tc-endian) == "little" ]] ) || use s390 || use x86; then
			GOFLAGS="-buildmode=pie ${GOFLAGS}"
	fi
	GOFLAGS="${GOFLAGS} -p=$(makeopts_jobs)"
	if [[ "${#EGO_SUM[@]}" -gt 0 ]]; then
		eqawarn "This ebuild uses EGO_SUM which is deprecated"
		eqawarn "Please migrate to a dependency tarball"
		eqawarn "This will become a fatal error in the future"
		_go-module_src_unpack_gosum
	elif [[ "${#EGO_VENDOR[@]}" -gt 0 ]]; then
		eerror "${EBUILD} is using EGO_VENDOR which is no longer supported"
		die "Please update this ebuild"
	else
		default
		if [[ ! -d "${S}"/vendor ]]; then
			cd "${S}"
			local nf
			[[ -n ${NONFATAL_VERIFY} ]] && nf=nonfatal
			${nf} ego mod verify
		fi
	fi
}

# @FUNCTION: _go-module_src_unpack_gosum
# @DEPRECATED: none
# @DESCRIPTION:
# Populate a GOPROXY directory hierarchy with distfiles from EGO_SUM and
# unpack the base distfiles.
#
# Exports GOPROXY environment variable so that Go calls will source the
# directory correctly.
_go-module_src_unpack_gosum() {
	# shellcheck disable=SC2120
	debug-print-function "${FUNCNAME}" "$@"

	if [[ ! ${_GO_MODULE_SET_GLOBALS_CALLED} ]]; then
		die "go-module_set_globals must be called in global scope"
	fi

	local goproxy_dir="${GOPROXY/file:\/\//}"
	mkdir -p "${goproxy_dir}" || die

	# For each Golang module distfile, look up where it's supposed to go, and
	# symlink into place.
	local f
	local goproxy_mod_dir
	for f in ${A}; do
		goproxy_mod_path="${_GOMODULE_GOSUM_REVERSE_MAP["${f}"]}"
		if [[ -n "${goproxy_mod_path}" ]]; then
			debug-print-function "Populating go proxy for ${goproxy_mod_path}"
			# Build symlink hierarchy
			goproxy_mod_dir=$( dirname "${goproxy_dir}"/"${goproxy_mod_path}" )
			mkdir -p "${goproxy_mod_dir}" || die
			ln -sf "${DISTDIR}"/"${f}" "${goproxy_dir}/${goproxy_mod_path}" ||
				die "Failed to ln"
			local v=${goproxy_mod_path}
			v="${v%.mod}"
			v="${v%.zip}"
			v="${v//*\/}"
			_go-module_gosum_synthesize_files "${goproxy_mod_dir}" "${v}"
		else
			unpack "$f"
		fi
	done

	# Validate the gosum now
	_go-module_src_unpack_verify_gosum
}

# @FUNCTION: _go-module_gosum_synthesize_files
# @DEPRECATED: none
# @DESCRIPTION:
# Given a path &  version, populate all Goproxy metadata files which aren't
# needed to be downloaded directly.
# - .../@v/${version}.info
# - .../@v/list
_go-module_gosum_synthesize_files() {
	local target=$1
	local version=$2
	# 'go get' doesn't care about the hash of the .info files, they
	# just need a 'version' element!
	# This saves a download of a tiny file
	# The .time key is omitted, because that is the time a module was added
	# to the upstream goproxy, and not metadata about the module itself.
	cat >"${target}/${version}.info" <<-EOF
	{
		"Version": "${version}",
		"shortName": "${version}",
		"Name": "${version}"
	}
	EOF
	listfile="${target}"/list
	if ! grep -sq -x -e "${version}" "${listfile}" 2>/dev/null; then
		echo "${version}" >>"${listfile}"
	fi
}

# @FUNCTION: _go-module_src_unpack_verify_gosum
# @DEPRECATED: none
# @DESCRIPTION:
# Validate the Go modules declared by EGO_SUM are sufficient to cover building
# the package, without actually building it yet.
_go-module_src_unpack_verify_gosum() {
	# shellcheck disable=SC2120
	debug-print-function "${FUNCNAME}" "$@"

	if [[ ! ${_GO_MODULE_SET_GLOBALS_CALLED} ]]; then
		die "go-module_set_globals must be called in global scope"
	fi

	cd "${S}" || die "cd failed"

	# Cleanup the modules before starting anything else
	# This will print 'downloading' messages, but it's accessing content from
	# the $GOPROXY file:/// URL!
	einfo "Tidying go.mod/go.sum"
	nonfatal ego mod tidy >/dev/null

	# This used to call 'go get' to verify by fetching everything from the main
	# go.mod. However 'go get' also turns out to recursively try to fetch
	# everything in dependencies, even materials that are used only for tests
	# of the dependencies, or code generation.
	# If EGO_SUM is missing an entry now, it will fail during the build process
	# rather than this helper function.
}

# @FUNCTION: go-module_live_vendor
# @DESCRIPTION:
# This function is used in live ebuilds to vendor the dependencies when
# upstream doesn't vendor them.
go-module_live_vendor() {
	debug-print-function "${FUNCNAME}" "$@"

	# shellcheck disable=SC2086
	has live ${PROPERTIES} ||
		die "${FUNCNAME} only allowed in live ebuilds"
	[[ "${EBUILD_PHASE}" == unpack ]] ||
		die "${FUNCNAME} only allowed in src_unpack"
	[[ -d "${S}"/vendor ]] &&
		die "${FUNCNAME} only allowed when upstream isn't vendoring"

	pushd "${S}" >& /dev/null || die
	ego mod vendor
	popd >& /dev/null || die
}

# @FUNCTION: _go-module_gomod_encode
# @DEPRECATED: none
# @DESCRIPTION:
# Encode the name(path) of a Golang module in the format expected by Goproxy.
#
# Upper letters are replaced by their lowercase version with a '!' prefix.
#
_go-module_gomod_encode() {
	## Python:
	# return re.sub('([A-Z]{1})', r'!\1', s).lower()

	## Sed:
	## This uses GNU Sed extension \l to downcase the match
	#echo "${module}" |sed 's,[A-Z],!\l&,g'
	#
	# Bash variant:
	debug-print-function "${FUNCNAME}" "$@"
	#local re input lower
	re='(.*)([A-Z])(.*)'
	input="${1}"
	while [[ ${input} =~ ${re} ]]; do
		lower='!'"${BASH_REMATCH[2],}"
		input="${BASH_REMATCH[1]}${lower}${BASH_REMATCH[3]}"
	done
	echo "${input}"
}

fi

if [[ ! ${GO_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_unpack
fi
