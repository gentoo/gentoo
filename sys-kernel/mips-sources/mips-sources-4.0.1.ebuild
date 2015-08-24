# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# EAPI Version
EAPI="5"

# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org GIT snapshot diff
# 3) Generic Fixes
# 4) Patch for the IOC3 Metadriver (IP27, IP30)
# 5) Patch for IP30 Support
# 6) Experimental patches (if needed)

#//------------------------------------------------------------------------------

# Version Data
OKV=${PV/_/-}
GITDATE="20150418"			# Date of diff between kernel.org and lmo GIT
GENPATCHREV="1"				# Tarball revision for patches

# Directories
S="${WORKDIR}/linux-${OKV}-${GITDATE}"
MIPS_PATCHES="${WORKDIR}/mips-patches"

# Kernel-2 Vars
K_SECURITY_UNSUPPORTED="1"
K_NOUSENAME="0"
K_NOUSEPR="0"
K_USEPV="0"
ETYPE="sources"

# Inherit Eclasses
inherit kernel-2 eutils
detect_version

# Version Data
F_KV="${PVR}"
BASE_KV="$(get_version_component_range 1-2).0"
[[ "${EXTRAVERSION}" = -rc* ]] && KVE="${EXTRAVERSION}"

# Portage Vars
HOMEPAGE="http://www.linux-mips.org/ https://www.gentoo.org/"
SLOT="${OKV}"
KEYWORDS="-* ~mips"
IUSE="cobalt ip27 ip28 ip30 ip32r10k"
DEPEND=">=sys-devel/gcc-4.6.0"
RDEPEND=""

# Machine Support Control Variables
DO_IP22="test"				# If "yes", enable IP22 support		(SGI Indy, Indigo2 R4x00)
DO_IP27="yes"				# 		   IP27 support		(SGI Origin)
DO_IP28="test"				# 		   IP28 support		(SGI Indigo2 Impact R10000)
DO_IP30="yes"				# 		   IP30 support		(SGI Octane)
DO_IP32="yes"				# 		   IP32 support		(SGI O2, R5000/RM5200 Only)
DO_CBLT="test"				# 		   Cobalt Support	(Cobalt Microsystems)

# Machine Stable Version Variables
SV_IP22=""				# If set && DO_IP22 == "no", indicates last "good" IP22 version
SV_IP27=""				# 	    DO_IP27 == "no", 			   IP27
SV_IP28=""				# 	    DO_IP28 == "no", 			   IP28
SV_IP30=""				# 	    DO_IP30 == "no", 			   IP30
SV_IP32=""				# 	    DO_IP32 == "no", 			   IP32
SV_CBLT=""				# 	    DO_CBLT == "no", 			   Cobalt

DESCRIPTION="Linux-Mips GIT sources for MIPS-based machines, dated ${GITDATE}"
SRC_URI="${KERNEL_URI}
	 mirror://gentoo/mipsgit-${BASE_KV}${KVE}-${GITDATE}.diff.xz
	 mirror://gentoo/${PN}-${BASE_KV}-patches-v${GENPATCHREV}.tar.xz"

UNIPATCH_STRICTORDER="1"
UNIPATCH_LIST="${DISTDIR}/mipsgit-${BASE_KV}${KVE}-${GITDATE}.diff.xz"

#//------------------------------------------------------------------------------

# Eblit Handling Functions
#
# They'll likely be superseded someday by better ideas, possibly elibs.

# eblit-core
# Usage: <function> [version]
# Main eblit engine
eblit-core() {
	local e v func=$1 ver=$2
	for v in ${ver:+-}${ver} -${PVR} -${PV} "" ; do
		e="${FILESDIR}/eblits/${func}${v}.eblit"
		if [[ -e ${e} ]] ; then
			. "${e}"
			[[ ${func} == pkg_* ]] && eval "${func}() { eblit-run ${func} ${ver} ; }"
			return 0
		fi
	done
	return 1
}

# eblit-include
# Usage: [--skip] <function> [version]
# Includes an "eblit" -- a chunk of common code among ebuilds in a given
# package so that its functions can be sourced and utilized within the
# ebuild.
eblit-include() {
	local skipable=false r=0
	[[ $1 == "--skip" ]] && skipable=true && shift
	[[ $1 == pkg_* ]] && skipable=true

	[[ -z $1 ]] && die "Usage: eblit-include <function> [version]"
	eblit-core $1 $2
	r="$?"
	${skipable} && return 0
	[[ "$r" -gt "0" ]] && die "Could not locate requested eblit '$1' in ${FILESDIR}/eblits/"
}

# eblit-run-maybe
# Usage: <function>
# Runs a function if it is defined in an eblit
eblit-run-maybe() {
	[[ $(type -t "$@") == "function" ]] && "$@"
}

# eblit-run
# Usage: <function> [version]
# Runs a function defined in an eblit
eblit-run() {
	eblit-include --skip common "${*:2}"
	eblit-include "$@"
	eblit-run-maybe eblit-$1-pre
	eblit-${PN}-$1
	eblit-run-maybe eblit-$1-post
}

# eblit-pkg
# Usage: <phase> [version]
# Runs the pkg_* functions AND evals them so they're included in the binpkgs
eblit-pkg() {
	[[ -z $1 ]] && die "Usage: eblit-pkg <phase> [version]"
	eblit-core pkg_$1 $2
}

#//------------------------------------------------------------------------------

load_eblit_funcs() {
	# This is a sanity check to avoid QA issues.  It prevents
	# eblits from being referenced during metadata operations.
	[ -n "${MIPS_SOURCES_EBLITS_LOADED}" ] && return

	# All are in ${FILESDIR}/eblits
	# If a message for a given machine needs to change,
	# then we create a new eblit and increment the
	# version and reference it here.
	eblit-include err_disabled_mach v1
	eblit-include err_only_one_mach_allowed v1
	eblit-include show_ip22_info v3
	eblit-include show_ip27_info v3
	eblit-include show_ip28_info v1
	eblit-include show_ip30_info v3
	eblit-include show_ip32_info v3
	eblit-include show_cobalt_info v1

	# This makes sure pkg_setup & pkg_postinst gets into any binpkg.
	# Neccessary because we can't guarantee FILESDIR is around for binpkgs.
	eblit-pkg setup v1
	eblit-pkg postinst v1

	# Eblit load complete
	MIPS_SOURCES_EBLITS_LOADED=1
}

pkg_setup() {
	load_eblit_funcs
	pkg_setup
}

src_unpack() { eblit-run src_unpack v5 ; }

#//------------------------------------------------------------------------------
