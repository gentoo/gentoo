# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Description: kernel.eclass rewrite for a clean base regarding the 2.6
#              series of kernel with back-compatibility for 2.4
#
# Original author: John Mylchreest <johnm@gentoo.org>
# Maintainer: kernel@gentoo.org
#
# Please direct your bugs to the current eclass maintainer :)

# added functionality:
# unipatch		- a flexible, singular method to extract, add and remove patches.

# A Couple of env vars are available to effect usage of this eclass
# These are as follows:
#
# K_USEPV				- When setting the EXTRAVERSION variable, it should
#						  add PV to the end.
#						  this is useful for thigns like wolk. IE:
#						  EXTRAVERSION would be something like : -wolk-4.19-r1
# K_NOSETEXTRAVERSION	- if this is set then EXTRAVERSION will not be
#						  automatically set within the kernel Makefile
# K_NOUSENAME			- if this is set then EXTRAVERSION will not include the
#						  first part of ${PN} in EXTRAVERSION
# K_NOUSEPR				- if this is set then EXTRAVERSION will not include the
#						  anything based on ${PR}.
# K_PREPATCHED			- if the patchset is prepatched (ie: mm-sources,
#						  ck-sources, ac-sources) it will use PR (ie: -r5) as
#						  the patchset version for
#						  and not use it as a true package revision
# K_EXTRAEINFO			- this is a new-line seperated list of einfo displays in
#						  postinst and can be used to carry additional postinst
#						  messages
# K_EXTRAELOG			- same as K_EXTRAEINFO except using elog instead of einfo
# K_EXTRAEWARN			- same as K_EXTRAEINFO except using ewarn instead of einfo
# K_SYMLINK				- if this is set, then forcably create symlink anyway
#
# K_BASE_VER			- for git-sources, declare the base version this patch is
#						  based off of.
# K_DEFCONFIG			- Allow specifying a different defconfig target.
#						  If length zero, defaults to "defconfig".
# K_WANT_GENPATCHES		- Apply genpatches to kernel source. Provide any
# 						  combination of "base", "extras" or "experimental".
# K_EXP_GENPATCHES_PULL	- If set, we pull "experimental" regardless of the USE FLAG
#						  but expect the ebuild maintainer to use K_EXP_GENPATCHES_LIST.
# K_EXP_GENPATCHES_NOUSE	- If set, no USE flag will be provided for "experimental";
# 						  as a result the user cannot choose to apply those patches.
# K_EXP_GENPATCHES_LIST	- A list of patches to pick from "experimental" to apply when
# 						  the USE flag is unset and K_EXP_GENPATCHES_PULL is set.
# K_GENPATCHES_VER		- The version of the genpatches tarball(s) to apply.
#						  A value of "5" would apply genpatches-2.6.12-5 to
#						  my-sources-2.6.12.ebuild
# K_SECURITY_UNSUPPORTED- If set, this kernel is unsupported by Gentoo Security
# K_DEBLOB_AVAILABLE	- A value of "0" will disable all of the optional deblob
#						  code. If empty, will be set to "1" if deblobbing is
#						  possible. Test ONLY for "1".
# K_DEBLOB_TAG     		- This will be the version of deblob script. It's a upstream SVN tag
#						  such asw -gnu or -gnu1.
# K_PREDEBLOBBED		- This kernel was already deblobbed elsewhere.
#						  If false, either optional deblobbing will be available
#						  or the license will note the inclusion of freedist
#						  code.
# K_LONGTERM			- If set, the eclass will search for the kernel source
#						  in the long term directories on the upstream servers
#						  as the location has been changed by upstream
# K_KDBUS_AVAILABLE		- If set, the ebuild contains the option of installing the
#						  kdbus patch.  This patch is not installed without the 'kdbus'
#						  and 'experimental' use flags.
# H_SUPPORTEDARCH		- this should be a space separated list of ARCH's which
#						  can be supported by the headers ebuild

# UNIPATCH_LIST			- space delimetered list of patches to be applied to the
#						  kernel
# UNIPATCH_EXCLUDE		- an addition var to support exlusion based completely
#						  on "<passedstring>*" and not "<passedno#>_*"
#						- this should _NOT_ be used from the ebuild as this is
#						  reserved for end users passing excludes from the cli
# UNIPATCH_DOCS			- space delimemeted list of docs to be installed to
#						  the doc dir
# UNIPATCH_STRICTORDER	- if this is set places patches into directories of
#						  order, so they are applied in the order passed

# Changing any other variable in this eclass is not supported; you can request
# for additional variables to be added by contacting the current maintainer.
# If you do change them, there is a chance that we will not fix resulting bugs;
# that of course does not mean we're not willing to help.

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils toolchain-funcs versionator multilib python-any-r1
EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test src_install pkg_preinst pkg_postinst pkg_postrm

# Added by Daniel Ostrow <dostrow@gentoo.org>
# This is an ugly hack to get around an issue with a 32-bit userland on ppc64.
# I will remove it when I come up with something more reasonable.
[[ ${PROFILE_ARCH} == "ppc64" ]] && CHOST="powerpc64-${CHOST#*-}"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} && ${CATEGORY/cross-} != ${CATEGORY} ]]; then
	export CTARGET=${CATEGORY/cross-}
fi

HOMEPAGE="https://www.kernel.org/ https://www.gentoo.org/ ${HOMEPAGE}"
: ${LICENSE:="GPL-2"}

has "${EAPI:-0}" 0 1 2 && ED=${D} EPREFIX= EROOT=${ROOT}

# This is the latest KV_PATCH of the deblob tool available from the
# libre-sources upstream. If you bump this, you MUST regenerate the Manifests
# for ALL kernel-2 consumer packages where deblob is available.
: ${DEBLOB_MAX_VERSION:=38}

# No need to run scanelf/strip on kernel sources/headers (bug #134453).
RESTRICT="binchecks strip"

# set LINUX_HOSTCFLAGS if not already set
: ${LINUX_HOSTCFLAGS:="-Wall -Wstrict-prototypes -Os -fomit-frame-pointer -I${S}/include"}

# debugging functions
#==============================================================
# this function exists only to help debug kernel-2.eclass
# if you are adding new functionality in, put a call to it
# at the start of src_unpack, or during SRC_URI/dep generation.
debug-print-kernel2-variables() {
	for v in PVR CKV OKV KV KV_FULL KV_MAJOR KV_MINOR KV_PATCH RELEASETYPE \
			RELEASE UNIPATCH_LIST_DEFAULT UNIPATCH_LIST_GENPATCHES \
			UNIPATCH_LIST S KERNEL_URI K_WANT_GENPATCHES ; do
		debug-print "${v}: ${!v}"
	done
}

#Eclass functions only from here onwards ...
#==============================================================
handle_genpatches() {
	local tarball want_unipatch_list
	[[ -z ${K_WANT_GENPATCHES} || -z ${K_GENPATCHES_VER} ]] && return 1

	if [[ -n ${1} ]]; then
		# set UNIPATCH_LIST_GENPATCHES only on explicit request
		# since that requires 'use' call which can be used only in phase
		# functions, while the function is also called in global scope
		if [[ ${1} == --set-unipatch-list ]]; then
			want_unipatch_list=1
		else
			die "Usage: ${FUNCNAME} [--set-unipatch-list]"
		fi
	fi

	debug-print "Inside handle_genpatches"
	local OKV_ARRAY
	IFS="." read -r -a OKV_ARRAY <<<"${OKV}"

	# for > 3.0 kernels, handle genpatches tarball name
	# genpatches for 3.0 and 3.0.1 might be named
	# genpatches-3.0-1.base.tar.xz and genpatches-3.0-2.base.tar.xz
	# respectively.  Handle this.

	for i in ${K_WANT_GENPATCHES} ; do
		if [[ ${KV_MAJOR} -ge 3 ]]; then
			if [[ ${#OKV_ARRAY[@]} -ge 3 ]]; then
				tarball="genpatches-${KV_MAJOR}.${KV_MINOR}-${K_GENPATCHES_VER}.${i}.tar.xz"
			else
				tarball="genpatches-${KV_MAJOR}.${KV_PATCH}-${K_GENPATCHES_VER}.${i}.tar.xz"
			fi
		else
			tarball="genpatches-${OKV}-${K_GENPATCHES_VER}.${i}.tar.xz"
		fi

		local use_cond_start="" use_cond_end=""

		if [[ "${i}" == "experimental" && -z ${K_EXP_GENPATCHES_PULL} && -z ${K_EXP_GENPATCHES_NOUSE} ]] ; then
			use_cond_start="experimental? ( "
			use_cond_end=" )"

			if [[ -n ${want_unipatch_list} ]] && use experimental ; then
				UNIPATCH_LIST_GENPATCHES+=" ${DISTDIR}/${tarball}"
				debug-print "genpatches tarball: $tarball"
			fi
		elif [[ -n ${want_unipatch_list} ]]; then
			UNIPATCH_LIST_GENPATCHES+=" ${DISTDIR}/${tarball}"
			debug-print "genpatches tarball: $tarball"
		fi
		GENPATCHES_URI+=" ${use_cond_start}mirror://gentoo/${tarball}${use_cond_end}"
	done
}

detect_version() {
	# this function will detect and set
	# - OKV: Original Kernel Version (2.6.0/2.6.0-test11)
	# - KV: Kernel Version (2.6.0-gentoo/2.6.0-test11-gentoo-r1)
	# - EXTRAVERSION: The additional version appended to OKV (-gentoo/-gentoo-r1)

	# We've already run, so nothing to do here.
	[[ -n ${KV_FULL} ]] && return 0

	# CKV is used as a comparison kernel version, which is used when
	# PV doesnt reflect the genuine kernel version.
	# this gets set to the portage style versioning. ie:
	#   CKV=2.6.11_rc4
	CKV=${CKV:-${PV}}
	OKV=${OKV:-${CKV}}
	OKV=${OKV/_beta/-test}
	OKV=${OKV/_rc/-rc}
	OKV=${OKV/-r*}
	OKV=${OKV/_p*}

	KV_MAJOR=$(get_version_component_range 1 ${OKV})
	# handle if OKV is X.Y or X.Y.Z (e.g. 3.0 or 3.0.1)
	local OKV_ARRAY
	IFS="." read -r -a OKV_ARRAY <<<"${OKV}"

	# if KV_MAJOR >= 3, then we have no more KV_MINOR
	#if [[ ${KV_MAJOR} -lt 3 ]]; then
	if [[ ${#OKV_ARRAY[@]} -ge 3 ]]; then
		KV_MINOR=$(get_version_component_range 2 ${OKV})
		KV_PATCH=$(get_version_component_range 3 ${OKV})
		if [[ ${KV_MAJOR}${KV_MINOR}${KV_PATCH} -ge 269 ]]; then
	        KV_EXTRA=$(get_version_component_range 4- ${OKV})
	        KV_EXTRA=${KV_EXTRA/[-_]*}
		else
			KV_PATCH=$(get_version_component_range 3- ${OKV})
		fi
	else
		KV_PATCH=$(get_version_component_range 2 ${OKV})
		KV_EXTRA=$(get_version_component_range 3- ${OKV})
		KV_EXTRA=${KV_EXTRA/[-_]*}
	fi

	debug-print "KV_EXTRA is ${KV_EXTRA}"

	KV_PATCH=${KV_PATCH/[-_]*}

	local v n=0 missing
	#if [[ ${KV_MAJOR} -lt 3 ]]; then
	if [[ ${#OKV_ARRAY[@]} -ge 3 ]]; then
		for v in CKV OKV KV_{MAJOR,MINOR,PATCH} ; do
			[[ -z ${!v} ]] && n=1 && missing="${missing}${v} ";
		done
	else
		for v in CKV OKV KV_{MAJOR,PATCH} ; do
			[[ -z ${!v} ]] && n=1 && missing="${missing}${v} ";
		done
	fi

	[[ $n -eq 1 ]] && \
		eerror "Missing variables: ${missing}" && \
		die "Failed to extract kernel version (try explicit CKV in ebuild)!"
	unset v n missing

#	if [[ ${KV_MAJOR} -ge 3 ]]; then
	if [[ ${#OKV_ARRAY[@]} -lt 3 ]]; then
		KV_PATCH_ARR=(${KV_PATCH//\./ })

		# at this point 031412, Linus is putting all 3.x kernels in a
		# 3.x directory, may need to revisit when 4.x is released
		KERNEL_BASE_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.x"

		[[ -n "${K_LONGTERM}" ]] &&
			KERNEL_BASE_URI="${KERNEL_BASE_URI}/longterm/v${KV_MAJOR}.${KV_PATCH_ARR}"
	else
		#KERNEL_BASE_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.0"
		#KERNEL_BASE_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.${KV_MINOR}"
		if [[ ${KV_MAJOR} -ge 3 ]]; then
			KERNEL_BASE_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.x"
		else
			KERNEL_BASE_URI="mirror://kernel/linux/kernel/v${KV_MAJOR}.${KV_MINOR}"
		fi

		[[ -n "${K_LONGTERM}" ]] &&
			#KERNEL_BASE_URI="${KERNEL_BASE_URI}/longterm"
			KERNEL_BASE_URI="${KERNEL_BASE_URI}/longterm/v${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
	fi

	debug-print "KERNEL_BASE_URI is ${KERNEL_BASE_URI}"

	if [[ ${#OKV_ARRAY[@]} -ge 3 ]] && [[ ${KV_MAJOR} -ge 3 ]]; then
		# handle non genpatch using sources correctly
		if [[ -z ${K_WANT_GENPATCHES} && -z ${K_GENPATCHES_VER} && ${KV_PATCH} -gt 0 ]]; then
			KERNEL_URI="${KERNEL_BASE_URI}/patch-${OKV}.xz"
			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${CKV}.xz"
		fi
		KERNEL_URI="${KERNEL_URI} ${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz"
	else
		KERNEL_URI="${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
	fi

	RELEASE=${CKV/${OKV}}
	RELEASE=${RELEASE/_beta}
	RELEASE=${RELEASE/_rc/-rc}
	RELEASE=${RELEASE/_pre/-pre}
	# We cannot trivally call kernel_is here, because it calls us to detect the
	# version
	#kernel_is ge 2 6 && RELEASE=${RELEASE/-pre/-git}
	[ $(($KV_MAJOR * 1000 + ${KV_MINOR:-0})) -ge 2006 ] && RELEASE=${RELEASE/-pre/-git}
	RELEASETYPE=${RELEASE//[0-9]}

	# Now we know that RELEASE is the -rc/-git
	# and RELEASETYPE is the same but with its numerics stripped
	# we can work on better sorting EXTRAVERSION.
	# first of all, we add the release
	EXTRAVERSION="${RELEASE}"
	debug-print "0 EXTRAVERSION:${EXTRAVERSION}"
	[[ -n ${KV_EXTRA} ]] && [[ ${KV_MAJOR} -lt 3 ]] && EXTRAVERSION=".${KV_EXTRA}${EXTRAVERSION}"

	debug-print "1 EXTRAVERSION:${EXTRAVERSION}"
	if [[ -n "${K_NOUSEPR}" ]]; then
		# Don't add anything based on PR to EXTRAVERSION
		debug-print "1.0 EXTRAVERSION:${EXTRAVERSION}"
	elif [[ -n ${K_PREPATCHED} ]]; then
		debug-print "1.1 EXTRAVERSION:${EXTRAVERSION}"
		EXTRAVERSION="${EXTRAVERSION}-${PN/-*}${PR/r}"
	elif [[ "${ETYPE}" = "sources" ]]; then
		debug-print "1.2 EXTRAVERSION:${EXTRAVERSION}"
		# For some sources we want to use the PV in the extra version
		# This is because upstream releases with a completely different
		# versioning scheme.
		case ${PN/-*} in
		     wolk) K_USEPV=1;;
		  vserver) K_USEPV=1;;
		esac

		[[ -z "${K_NOUSENAME}" ]] && EXTRAVERSION="${EXTRAVERSION}-${PN/-*}"
		[[ -n "${K_USEPV}" ]]     && EXTRAVERSION="${EXTRAVERSION}-${PV//_/-}"
		[[ -n "${PR//r0}" ]] && EXTRAVERSION="${EXTRAVERSION}-${PR}"
	fi
	debug-print "2 EXTRAVERSION:${EXTRAVERSION}"

	# The only messing around which should actually effect this is for KV_EXTRA
	# since this has to limit OKV to MAJ.MIN.PAT and strip EXTRA off else
	# KV_FULL evaluates to MAJ.MIN.PAT.EXT.EXT after EXTRAVERSION

	if [[ -n ${KV_EXTRA} ]]; then
		if [[ -n ${KV_MINOR} ]]; then
			OKV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
		else
			OKV="${KV_MAJOR}.${KV_PATCH}"
		fi
		KERNEL_URI="${KERNEL_BASE_URI}/patch-${CKV}.xz
					${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
		UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${CKV}.xz"
	fi

	# We need to set this using OKV, but we need to set it before we do any
	# messing around with OKV based on RELEASETYPE
	KV_FULL=${OKV}${EXTRAVERSION}

	# we will set this for backwards compatibility.
	S="${WORKDIR}"/linux-${KV_FULL}
	KV=${KV_FULL}

	# -rc-git pulls can be achieved by specifying CKV
	# for example:
	#   CKV="2.6.11_rc3_pre2"
	# will pull:
	#   linux-2.6.10.tar.xz & patch-2.6.11-rc3.xz & patch-2.6.11-rc3-git2.xz

	if [[ ${KV_MAJOR}${KV_MINOR} -eq 26 ]]; then

		if [[ ${RELEASETYPE} == -rc ]] || [[ ${RELEASETYPE} == -pre ]]; then
			OKV="${KV_MAJOR}.${KV_MINOR}.$((${KV_PATCH} - 1))"
			KERNEL_URI="${KERNEL_BASE_URI}/testing/patch-${CKV//_/-}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${CKV//_/-}.xz"
		fi

		if [[ ${RELEASETYPE} == -git ]]; then
			KERNEL_URI="${KERNEL_BASE_URI}/snapshots/patch-${OKV}${RELEASE}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${OKV}${RELEASE}.xz"
		fi

		if [[ ${RELEASETYPE} == -rc-git ]]; then
			OKV="${KV_MAJOR}.${KV_MINOR}.$((${KV_PATCH} - 1))"
			KERNEL_URI="${KERNEL_BASE_URI}/snapshots/patch-${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${RELEASE}.xz
						${KERNEL_BASE_URI}/testing/patch-${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${RELEASE/-git*}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"

			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${RELEASE/-git*}.xz ${DISTDIR}/patch-${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${RELEASE}.xz"
		fi
	else
		KV_PATCH_ARR=(${KV_PATCH//\./ })

		# the different majorminor versions have different patch start versions
		OKV_DICT=(["2"]="${KV_MAJOR}.$((${KV_PATCH_ARR} - 1))" ["3"]="2.6.39" ["4"]="3.19")

		if [[ ${RELEASETYPE} == -rc ]] || [[ ${RELEASETYPE} == -pre ]]; then
			OKV=${K_BASE_VER:-$OKV_DICT["${KV_MAJOR}"]}
			KERNEL_URI="${KERNEL_BASE_URI}/testing/patch-${CKV//_/-}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${CKV//_/-}.xz"
		fi

		if [[ ${RELEASETYPE} == -git ]]; then
			KERNEL_URI="${KERNEL_BASE_URI}/snapshots/patch-${OKV}${RELEASE}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"
			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${OKV}${RELEASE}.xz"
		fi

		if [[ ${RELEASETYPE} == -rc-git ]]; then
			OKV=${K_BASE_VER:-$OKV_DICT["${KV_MAJOR}"]}
			KERNEL_URI="${KERNEL_BASE_URI}/snapshots/patch-${KV_MAJOR}.${KV_PATCH}${RELEASE}.xz
						${KERNEL_BASE_URI}/testing/patch-${KV_MAJOR}.${KV_PATCH}${RELEASE/-git*}.xz
						${KERNEL_BASE_URI}/linux-${OKV}.tar.xz"

			UNIPATCH_LIST_DEFAULT="${DISTDIR}/patch-${KV_MAJOR}.${KV_PATCH}${RELEASE/-git*}.xz ${DISTDIR}/patch-${KV_MAJOR}.${KV_PATCH}${RELEASE}.xz"
		fi


	fi

	debug-print-kernel2-variables

	handle_genpatches
}

# Note: duplicated in linux-info.eclass
kernel_is() {
	# ALL of these should be set before we can safely continue this function.
	# some of the sources have in the past had only one set.
	local v n=0
	for v in OKV KV_{MAJOR,MINOR,PATCH} ; do [[ -z ${!v} ]] && n=1 ; done
	[[ $n -eq 1 ]] && detect_version
	unset v n

	# Now we can continue
	local operator test value

	case ${1#-} in
	  lt) operator="-lt"; shift;;
	  gt) operator="-gt"; shift;;
	  le) operator="-le"; shift;;
	  ge) operator="-ge"; shift;;
	  eq) operator="-eq"; shift;;
	   *) operator="-eq";;
	esac
	[[ $# -gt 3 ]] && die "Error in kernel-2_kernel_is(): too many parameters"

	: $(( test = (KV_MAJOR << 16) + (KV_MINOR << 8) + KV_PATCH ))
	: $(( value = (${1:-${KV_MAJOR}} << 16) + (${2:-${KV_MINOR}} << 8) + ${3:-${KV_PATCH}} ))
	[ ${test} ${operator} ${value} ]
}

kernel_is_2_4() {
	kernel_is 2 4
}

kernel_is_2_6() {
	kernel_is 2 6 || kernel_is 2 5
}

# Capture the sources type and set DEPENDs
if [[ ${ETYPE} == sources ]]; then
	DEPEND="!build? (
		sys-apps/sed
		>=sys-devel/binutils-2.11.90.0.31
	)"
	RDEPEND="!build? (
		>=sys-libs/ncurses-5.2
		sys-devel/make
		dev-lang/perl
		sys-devel/bc
	)"

	SLOT="${PVR}"
	DESCRIPTION="Sources based on the Linux Kernel."
	IUSE="symlink build"

	if [[ -n ${K_KDBUS_AVAILABLE} ]]; then
		IUSE="${IUSE} kdbus"
	fi

	# Bug #266157, deblob for libre support
	if [[ -z ${K_PREDEBLOBBED} ]] ; then
		# Bug #359865, force a call to detect_version if needed
		kernel_is ge 2 6 27 && \
			[[ -z "${K_DEBLOB_AVAILABLE}" ]] && \
				kernel_is le 2 6 ${DEBLOB_MAX_VERSION} && \
					K_DEBLOB_AVAILABLE=1
		if [[ ${K_DEBLOB_AVAILABLE} == "1" ]] ; then
			IUSE="${IUSE} deblob"

			# Reflect that kernels contain firmware blobs unless otherwise
			# stripped
			LICENSE="${LICENSE} !deblob? ( freedist )"

			DEPEND+=" deblob? ( ${PYTHON_DEPS} )"

			if [[ -n KV_MINOR ]]; then
				DEBLOB_PV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}"
			else
				DEBLOB_PV="${KV_MAJOR}.${KV_PATCH}"
			fi

			if [[ ${KV_MAJOR} -ge 3 ]]; then
				DEBLOB_PV="${KV_MAJOR}.${KV_MINOR}"
			fi

			# deblob svn tag, default is -gnu, to change, use K_DEBLOB_TAG in ebuild
			K_DEBLOB_TAG=${K_DEBLOB_TAG:--gnu}
			DEBLOB_A="deblob-${DEBLOB_PV}"
			DEBLOB_CHECK_A="deblob-check-${DEBLOB_PV}"
			DEBLOB_HOMEPAGE="http://www.fsfla.org/svn/fsfla/software/linux-libre/releases/tags"
			DEBLOB_URI_PATH="${DEBLOB_PV}${K_DEBLOB_TAG}"
			if ! has "${EAPI:-0}" 0 1 ; then
				DEBLOB_CHECK_URI="${DEBLOB_HOMEPAGE}/${DEBLOB_URI_PATH}/deblob-check -> ${DEBLOB_CHECK_A}"
			else
				DEBLOB_CHECK_URI="mirror://gentoo/${DEBLOB_CHECK_A}"
			fi

			DEBLOB_URI="${DEBLOB_HOMEPAGE}/${DEBLOB_URI_PATH}/${DEBLOB_A}"
			HOMEPAGE="${HOMEPAGE} ${DEBLOB_HOMEPAGE}"

			KERNEL_URI="${KERNEL_URI}
				deblob? (
					${DEBLOB_URI}
					${DEBLOB_CHECK_URI}
				)"
		else
			# We have no way to deblob older kernels, so just mark them as
			# tainted with non-libre materials.
			LICENSE="${LICENSE} freedist"
		fi
	fi

elif [[ ${ETYPE} == headers ]]; then
	DESCRIPTION="Linux system headers"

	# Since we should NOT honour KBUILD_OUTPUT in headers
	# lets unset it here.
	unset KBUILD_OUTPUT

	SLOT="0"
else
	eerror "Unknown ETYPE=\"${ETYPE}\", must be \"sources\" or \"headers\""
	die "Unknown ETYPE=\"${ETYPE}\", must be \"sources\" or \"headers\""
fi

# Cross-compile support functions
#==============================================================
kernel_header_destdir() {
	[[ ${CTARGET} == ${CHOST} ]] \
		&& echo /usr/include \
		|| echo /usr/${CTARGET}/usr/include
}

cross_pre_c_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

env_setup_xmakeopts() {
	# Kernel ARCH != portage ARCH
	export KARCH=$(tc-arch-kernel)

	# When cross-compiling, we need to set the ARCH/CROSS_COMPILE
	# variables properly or bad things happen !
	xmakeopts="ARCH=${KARCH}"
	if [[ ${CTARGET} != ${CHOST} ]] && ! cross_pre_c_headers ; then
		xmakeopts="${xmakeopts} CROSS_COMPILE=${CTARGET}-"
	elif type -p ${CHOST}-ar > /dev/null ; then
		xmakeopts="${xmakeopts} CROSS_COMPILE=${CHOST}-"
	fi
	export xmakeopts
}

# Unpack functions
#==============================================================
unpack_2_4() {
	# this file is required for other things to build properly,
	# so we autogenerate it
	make -s mrproper ${xmakeopts} || die "make mrproper failed"
	make -s symlinks ${xmakeopts} || die "make symlinks failed"
	make -s include/linux/version.h ${xmakeopts} || die "make include/linux/version.h failed"
	echo ">>> version.h compiled successfully."
}

unpack_2_6() {
	# this file is required for other things to build properly, so we
	# autogenerate it ... generate a .config to keep version.h build from
	# spitting out an annoying warning
	make -s mrproper ${xmakeopts} 2>/dev/null \
		|| die "make mrproper failed"

	# quick fix for bug #132152 which triggers when it cannot include linux
	# headers (ie, we have not installed it yet)
	if ! make -s defconfig ${xmakeopts} &>/dev/null 2>&1 ; then
		touch .config
		eerror "make defconfig failed."
		eerror "assuming you dont have any headers installed yet and continuing"
		epause 5
	fi

	make -s include/linux/version.h ${xmakeopts} 2>/dev/null \
		|| die "make include/linux/version.h failed"
	rm -f .config >/dev/null
}

universal_unpack() {
	debug-print "Inside universal_unpack"

	local OKV_ARRAY
	IFS="." read -r -a OKV_ARRAY <<<"${OKV}"

	cd "${WORKDIR}"
	if [[ ${#OKV_ARRAY[@]} -ge 3 ]] && [[ ${KV_MAJOR} -ge 3 ]]; then
		unpack linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	else
		unpack linux-${OKV}.tar.xz
	fi

	if [[ -d "linux" ]]; then
		debug-print "Moving linux to linux-${KV_FULL}"
		mv linux linux-${KV_FULL} \
			|| die "Unable to move source tree to ${KV_FULL}."
	elif [[ "${OKV}" != "${KV_FULL}" ]]; then
		if [[ ${#OKV_ARRAY[@]} -ge 3 ]] && [[ ${KV_MAJOR} -ge 3 ]] &&
			[[ "${ETYPE}" = "sources" ]]; then
			debug-print "moving linux-${KV_MAJOR}.${KV_MINOR} to linux-${KV_FULL} "
			mv linux-${KV_MAJOR}.${KV_MINOR} linux-${KV_FULL} \
				|| die "Unable to move source tree to ${KV_FULL}."
		else
			debug-print "moving linux-${OKV} to linux-${KV_FULL} "
			mv linux-${OKV} linux-${KV_FULL} \
				|| die "Unable to move source tree to ${KV_FULL}."
		fi
	elif [[ ${#OKV_ARRAY[@]} -ge 3 ]] && [[ ${KV_MAJOR} -ge 3 ]]; then
		mv linux-${KV_MAJOR}.${KV_MINOR} linux-${KV_FULL} \
			|| die "Unable to move source tree to ${KV_FULL}."
	fi
	cd "${S}"

	# remove all backup files
	find . -iname "*~" -exec rm {} \; 2> /dev/null

}

unpack_set_extraversion() {
	cd "${S}"
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" Makefile
	cd "${OLDPWD}"
}

# Should be done after patches have been applied
# Otherwise patches that modify the same area of Makefile will fail
unpack_fix_install_path() {
	cd "${S}"
	sed	-i -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' Makefile
}

# Compile Functions
#==============================================================
compile_headers() {
	env_setup_xmakeopts

	# if we couldnt obtain HOSTCFLAGS from the Makefile,
	# then set it to something sane
	local HOSTCFLAGS=$(getfilevar HOSTCFLAGS "${S}"/Makefile)
	HOSTCFLAGS=${HOSTCFLAGS:--Wall -Wstrict-prototypes -O2 -fomit-frame-pointer}

	if kernel_is 2 4; then
		yes "" | make oldconfig ${xmakeopts}
		echo ">>> make oldconfig complete"
		make dep ${xmakeopts}
	elif kernel_is 2 6; then
		# 2.6.18 introduces headers_install which means we dont need any
		# of this crap anymore :D
		kernel_is ge 2 6 18 && return 0

		# autoconf.h isnt generated unless it already exists. plus, we have
		# no guarantee that any headers are installed on the system...
		[[ -f ${EROOT}usr/include/linux/autoconf.h ]] \
			|| touch include/linux/autoconf.h

		# if K_DEFCONFIG isn't set, force to "defconfig"
		# needed by mips
		if [[ -z ${K_DEFCONFIG} ]]; then
			if [[ $(KV_to_int ${KV}) -ge $(KV_to_int 2.6.16) ]]; then
				case ${CTARGET} in
					powerpc64*)	K_DEFCONFIG="ppc64_defconfig";;
					powerpc*)	K_DEFCONFIG="pmac32_defconfig";;
					*)			K_DEFCONFIG="defconfig";;
				esac
			else
				K_DEFCONFIG="defconfig"
			fi
		fi

		# if there arent any installed headers, then there also isnt an asm
		# symlink in /usr/include/, and make defconfig will fail, so we have
		# to force an include path with $S.
		HOSTCFLAGS="${HOSTCFLAGS} -I${S}/include/"
		ln -sf asm-${KARCH} "${S}"/include/asm || die
		cross_pre_c_headers && return 0

		make ${K_DEFCONFIG} HOSTCFLAGS="${HOSTCFLAGS}" ${xmakeopts} || die "defconfig failed (${K_DEFCONFIG})"
		if compile_headers_tweak_config ; then
			yes "" | make oldconfig HOSTCFLAGS="${HOSTCFLAGS}" ${xmakeopts} || die "2nd oldconfig failed"
		fi
		make prepare HOSTCFLAGS="${HOSTCFLAGS}" ${xmakeopts} || die "prepare failed"
		make prepare-all HOSTCFLAGS="${HOSTCFLAGS}" ${xmakeopts} || die "prepare failed"
	fi
}

compile_headers_tweak_config() {
	# some targets can be very very picky, so let's finesse the
	# .config based upon any info we may have
	case ${CTARGET} in
	sh*)
		sed -i '/CONFIG_CPU_SH/d' .config || die
		echo "CONFIG_CPU_SH${CTARGET:2:1}=y" >> .config
		return 0;;
	esac

	# no changes, so lets do nothing
	return 1
}

# install functions
#==============================================================
install_universal() {
	# Fix silly permissions in tarball
	cd "${WORKDIR}"
	chown -R 0:0 * >& /dev/null
	chmod -R a+r-w+X,u+w *
	cd ${OLDPWD}
}

install_headers() {
	local ddir=$(kernel_header_destdir)

	# 2.6.18 introduces headers_install which means we dont need any
	# of this crap anymore :D
	if kernel_is ge 2 6 18 ; then
		env_setup_xmakeopts
		emake headers_install INSTALL_HDR_PATH="${ED}"${ddir}/.. ${xmakeopts} || die

		# let other packages install some of these headers
		rm -rf "${ED}"${ddir}/scsi || die #glibc/uclibc/etc...
		return 0
	fi

	# Do not use "linux/*" as that can cause problems with very long
	# $S values where the cmdline to cp is too long
	pushd "${S}" >/dev/null
	dodir ${ddir}/linux
	cp -pPR "${S}"/include/linux "${ED}"${ddir}/ || die
	rm -rf "${ED}"${ddir}/linux/modules || die

	dodir ${ddir}/asm
	cp -pPR "${S}"/include/asm/* "${ED}"${ddir}/asm || die

	if kernel_is 2 6 ; then
		dodir ${ddir}/asm-generic
		cp -pPR "${S}"/include/asm-generic/* "${ED}"${ddir}/asm-generic || die
	fi

	# clean up
	find "${D}" -name '*.orig' -exec rm -f {} \;

	popd >/dev/null
}

install_sources() {
	local file

	cd "${S}"
	dodir /usr/src
	echo ">>> Copying sources ..."

	file="$(find ${WORKDIR} -iname "docs" -type d)"
	if [[ -n ${file} ]]; then
		for file in $(find ${file} -type f); do
			echo "${file//*docs\/}" >> "${S}"/patches.txt
			echo "===================================================" >> "${S}"/patches.txt
			cat ${file} >> "${S}"/patches.txt
			echo "===================================================" >> "${S}"/patches.txt
			echo "" >> "${S}"/patches.txt
		done
	fi

	if [[ ! -f ${S}/patches.txt ]]; then
		# patches.txt is empty so lets use our ChangeLog
		[[ -f ${FILESDIR}/../ChangeLog ]] && \
			echo "Please check the ebuild ChangeLog for more details." \
			> "${S}"/patches.txt
	fi

	mv "${WORKDIR}"/linux* "${ED}"usr/src || die

	if [[ -n "${UNIPATCH_DOCS}" ]] ; then
		for i in ${UNIPATCH_DOCS}; do
			dodoc "${T}"/${i}
		done
	fi
}

# pkg_preinst functions
#==============================================================
preinst_headers() {
	local ddir=$(kernel_header_destdir)
	[[ -L ${EPREFIX}${ddir}/linux ]] && { rm "${EPREFIX}"${ddir}/linux || die; }
	[[ -L ${EPREFIX}${ddir}/asm ]] && { rm "${EPREFIX}"${ddir}/asm || die; }
}

# pkg_postinst functions
#==============================================================
postinst_sources() {
	local MAKELINK=0

	# if we have USE=symlink, then force K_SYMLINK=1
	use symlink && K_SYMLINK=1

	# We do support security on a deblobbed kernel, bug #555878.
	# If some particular kernel version doesn't have security
	# supported because of USE=deblob or otherwise, one can still
	# set K_SECURITY_UNSUPPORTED on a per ebuild basis.
	#[[ $K_DEBLOB_AVAILABLE == 1 ]] && \
	#	use deblob && \
	#	K_SECURITY_UNSUPPORTED=deblob

	# if we are to forcably symlink, delete it if it already exists first.
	if [[ ${K_SYMLINK} > 0 ]]; then
		[[ -h ${EROOT}usr/src/linux ]] && { rm "${EROOT}"usr/src/linux || die; }
		MAKELINK=1
	fi

	# if the link doesnt exist, lets create it
	[[ ! -h ${EROOT}usr/src/linux ]] && MAKELINK=1

	if [[ ${MAKELINK} == 1 ]]; then
		ln -sf linux-${KV_FULL} "${EROOT}"usr/src/linux || die
	fi

	# Don't forget to make directory for sysfs
	[[ ! -d ${EROOT}sys ]] && kernel_is 2 6 && { mkdir "${EROOT}"sys || die ; }

	echo
	elog "If you are upgrading from a previous kernel, you may be interested"
	elog "in the following document:"
	elog "  - General upgrade guide: https://wiki.gentoo.org/wiki/Kernel/Upgrade"
	echo

	# if K_EXTRAEINFO is set then lets display it now
	if [[ -n ${K_EXTRAEINFO} ]]; then
		echo ${K_EXTRAEINFO} | fmt |
		while read -s ELINE; do	einfo "${ELINE}"; done
	fi

	# if K_EXTRAELOG is set then lets display it now
	if [[ -n ${K_EXTRAELOG} ]]; then
		echo ${K_EXTRAELOG} | fmt |
		while read -s ELINE; do	elog "${ELINE}"; done
	fi

	# if K_EXTRAEWARN is set then lets display it now
	if [[ -n ${K_EXTRAEWARN} ]]; then
		echo ${K_EXTRAEWARN} | fmt |
		while read -s ELINE; do ewarn "${ELINE}"; done
	fi

	# optionally display security unsupported message
	#  Start with why
	if [[ -n ${K_SECURITY_UNSUPPORTED} ]]; then
		ewarn "${PN} is UNSUPPORTED by Gentoo Security."
	fi
	#  And now the general message.
	if [[ -n ${K_SECURITY_UNSUPPORTED} ]]; then
		ewarn "This means that it is likely to be vulnerable to recent security issues."
		ewarn "For specific information on why this kernel is unsupported, please read:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Kernel_Security"
	fi

	# warn sparc users that they need to do cross-compiling with >= 2.6.25(bug #214765)
	KV_MAJOR=$(get_version_component_range 1 ${OKV})
	KV_MINOR=$(get_version_component_range 2 ${OKV})
	KV_PATCH=$(get_version_component_range 3 ${OKV})
	if [[ "$(tc-arch)" = "sparc" ]]; then
		if [[ $(gcc-major-version) -lt 4 && $(gcc-minor-version) -lt 4 ]]; then
			if [[ ${KV_MAJOR} -ge 3 || ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH} > 2.6.24 ]] ; then
				echo
				elog "NOTE: Since 2.6.25 the kernel Makefile has changed in a way that"
				elog "you now need to do"
				elog "  make CROSS_COMPILE=sparc64-unknown-linux-gnu-"
				elog "instead of just"
				elog "  make"
				elog "to compile the kernel. For more information please browse to"
				elog "https://bugs.gentoo.org/show_bug.cgi?id=214765"
				echo
			fi
		fi
	fi
}

# pkg_setup functions
#==============================================================
setup_headers() {
	[[ -z ${H_SUPPORTEDARCH} ]] && H_SUPPORTEDARCH=${PN/-*/}
	for i in ${H_SUPPORTEDARCH}; do
		[[ $(tc-arch) == "${i}" ]] && H_ACCEPT_ARCH="yes"
	done

	if [[ ${H_ACCEPT_ARCH} != "yes" ]]; then
		echo
		eerror "This version of ${PN} does not support $(tc-arch)."
		eerror "Please merge the appropriate sources, in most cases"
		eerror "(but not all) this will be called $(tc-arch)-headers."
		die "Package unsupported for $(tc-arch)"
	fi
}

# unipatch
#==============================================================
unipatch() {
	local i x y z extention PIPE_CMD UNIPATCH_DROP KPATCH_DIR PATCH_DEPTH ELINE
	local STRICT_COUNT PATCH_LEVEL myLC_ALL myLANG

	# set to a standard locale to ensure sorts are ordered properly.
	myLC_ALL="${LC_ALL}"
	myLANG="${LANG}"
	LC_ALL="C"
	LANG=""

	[ -z "${KPATCH_DIR}" ] && KPATCH_DIR="${WORKDIR}/patches/"
	[ ! -d ${KPATCH_DIR} ] && mkdir -p ${KPATCH_DIR}

	# We're gonna need it when doing patches with a predefined patchlevel
	eshopts_push -s extglob

	# This function will unpack all passed tarballs, add any passed patches, and remove any passed patchnumbers
	# usage can be either via an env var or by params
	# although due to the nature we pass this within this eclass
	# it shall be by param only.
	# -z "${UNIPATCH_LIST}" ] && UNIPATCH_LIST="${@}"
	UNIPATCH_LIST="${@}"

	#unpack any passed tarballs
	for i in ${UNIPATCH_LIST}; do
		if echo ${i} | grep -qs -e "\.tar" -e "\.tbz" -e "\.tgz" ; then
			if [ -n "${UNIPATCH_STRICTORDER}" ]; then
				unset z
				STRICT_COUNT=$((10#${STRICT_COUNT} + 1))
				for((y=0; y<$((6 - ${#STRICT_COUNT})); y++));
					do z="${z}0";
				done
				PATCH_ORDER="${z}${STRICT_COUNT}"

				mkdir -p "${KPATCH_DIR}/${PATCH_ORDER}"
				pushd "${KPATCH_DIR}/${PATCH_ORDER}" >/dev/null
				unpack ${i##*/}
				popd >/dev/null
			else
				pushd "${KPATCH_DIR}" >/dev/null
				unpack ${i##*/}
				popd >/dev/null
			fi

			[[ ${i} == *:* ]] && echo ">>> Strict patch levels not currently supported for tarballed patchsets"
		else
			extention=${i/*./}
			extention=${extention/:*/}
			PIPE_CMD=""
			case ${extention} in
				     xz) PIPE_CMD="xz -dc";;
				   lzma) PIPE_CMD="lzma -dc";;
				    bz2) PIPE_CMD="bzip2 -dc";;
				 patch*) PIPE_CMD="cat";;
				   diff) PIPE_CMD="cat";;
				 gz|Z|z) PIPE_CMD="gzip -dc";;
				ZIP|zip) PIPE_CMD="unzip -p";;
				      *) UNIPATCH_DROP="${UNIPATCH_DROP} ${i/:*/}";;
			esac

			PATCH_LEVEL=${i/*([^:])?(:)}
			i=${i/:*/}
			x=${i/*\//}
			x=${x/\.${extention}/}

			if [ -n "${PIPE_CMD}" ]; then
				if [ ! -r "${i}" ]; then
					echo
					eerror "FATAL: unable to locate:"
					eerror "${i}"
					eerror "for read-only. The file either has incorrect permissions"
					eerror "or does not exist."
					die Unable to locate ${i}
				fi

				if [ -n "${UNIPATCH_STRICTORDER}" ]; then
					unset z
					STRICT_COUNT=$((10#${STRICT_COUNT} + 1))
					for((y=0; y<$((6 - ${#STRICT_COUNT})); y++));
						do z="${z}0";
					done
					PATCH_ORDER="${z}${STRICT_COUNT}"

					mkdir -p ${KPATCH_DIR}/${PATCH_ORDER}/
					$(${PIPE_CMD} ${i} > ${KPATCH_DIR}/${PATCH_ORDER}/${x}.patch${PATCH_LEVEL}) || die "uncompressing patch failed"
				else
					$(${PIPE_CMD} ${i} > ${KPATCH_DIR}/${x}.patch${PATCH_LEVEL}) || die "uncompressing patch failed"
				fi
			fi
		fi

		# If experimental was not chosen by the user, drop experimental patches not in K_EXP_GENPATCHES_LIST.
		if [[ "${i}" == *"genpatches-"*".experimental."* && -n ${K_EXP_GENPATCHES_PULL} ]] ; then
			if [[ -z ${K_EXP_GENPATCHES_NOUSE} ]] && use experimental; then
				continue
			fi

			local j
			for j in ${KPATCH_DIR}/*/50*_*.patch*; do
				for k in ${K_EXP_GENPATCHES_LIST} ; do
					[[ "$(basename ${j})" == ${k}* ]] && continue 2
				done
				UNIPATCH_DROP+=" $(basename ${j})"
			done
		else
			UNIPATCH_LIST_GENPATCHES+=" ${DISTDIR}/${tarball}"
			debug-print "genpatches tarball: $tarball"

			# check gcc version < 4.9.X uses patch 5000 and = 4.9.X uses patch 5010
			if [[ $(gcc-major-version) -eq 4 ]] && [[ $(gcc-minor-version) -ne 9 ]]; then
				# drop 5000_enable-additional-cpu-optimizations-for-gcc-4.9.patch
				if [[ $UNIPATCH_DROP != *"5010_enable-additional-cpu-optimizations-for-gcc-4.9.patch"* ]]; then
					UNIPATCH_DROP+=" 5010_enable-additional-cpu-optimizations-for-gcc-4.9.patch"
				fi
			else
				if [[ $UNIPATCH_DROP != *"5000_enable-additional-cpu-optimizations-for-gcc.patch"* ]]; then
					#drop 5000_enable-additional-cpu-optimizations-for-gcc.patch
					UNIPATCH_DROP+=" 5000_enable-additional-cpu-optimizations-for-gcc.patch"
				fi
			fi

			# if kdbus use flag is not set, drop the kdbus patch
            if [[ $UNIPATCH_DROP != *"5015_kdbus*.patch"* ]]; then
				if ! has kdbus ${IUSE} ||  ! use kdbus; then
					UNIPATCH_DROP="${UNIPATCH_DROP} 5015_kdbus*.patch"
				fi
			fi
 		fi
	done

	#populate KPATCH_DIRS so we know where to look to remove the excludes
	x=${KPATCH_DIR}
	KPATCH_DIR=""
	for i in $(find ${x} -type d | sort -n); do
		KPATCH_DIR="${KPATCH_DIR} ${i}"
	done

	# do not apply fbcondecor patch to sparc/sparc64 as it breaks boot
	# bug #272676
	if [[ "$(tc-arch)" = "sparc" || "$(tc-arch)" = "sparc64" ]]; then
		if [[ ${KV_MAJOR} -ge 3 || ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH} > 2.6.28 ]]; then
			UNIPATCH_DROP="${UNIPATCH_DROP} *_fbcondecor-0.9.6.patch"
			echo
			ewarn "fbcondecor currently prevents sparc/sparc64 from booting"
			ewarn "for kernel versions >= 2.6.29. Removing fbcondecor patch."
			ewarn "See https://bugs.gentoo.org/show_bug.cgi?id=272676 for details"
			echo
		fi
	fi

	#so now lets get rid of the patchno's we want to exclude
	UNIPATCH_DROP="${UNIPATCH_EXCLUDE} ${UNIPATCH_DROP}"
	for i in ${UNIPATCH_DROP}; do
		ebegin "Excluding Patch #${i}"
		for x in ${KPATCH_DIR}; do rm -f ${x}/${i}* 2>/dev/null; done
		eend $?
	done

	# and now, finally, we patch it :)
	for x in ${KPATCH_DIR}; do
		for i in $(find ${x} -maxdepth 1 -iname "*.patch*" -or -iname "*.diff*" | sort -n); do
			STDERR_T="${T}/${i/*\//}"
			STDERR_T="${STDERR_T/.patch*/.err}"

			[ -z ${i/*.patch*/} ] && PATCH_DEPTH=${i/*.patch/}
			#[ -z ${i/*.diff*/} ]  && PATCH_DEPTH=${i/*.diff/}

			if [ -z "${PATCH_DEPTH}" ]; then PATCH_DEPTH=0; fi

			####################################################################
			# IMPORTANT: This is temporary code to support Linux git 3.15_rc1! #
			#                                                                  #
			# The patch contains a removal of a symlink, followed by addition  #
			# of a file with the same name as the symlink in the same          #
			# location; this causes the dry-run to fail, filed bug #507656.    #
			#                                                                  #
			# https://bugs.gentoo.org/show_bug.cgi?id=507656                   #
			####################################################################
			if [[ ${PN} == "git-sources" ]] ; then
				if [[ ${KV_MAJOR} -gt 3 || ( ${KV_MAJOR} -eq 3 && ${KV_PATCH} -gt 15 ) &&
					${RELEASETYPE} == -rc ]] ; then
					ebegin "Applying ${i/*\//} (-p1)"
					if [ $(patch -p1 --no-backup-if-mismatch -f < ${i} >> ${STDERR_T}) "$?" -le 2 ]; then
						eend 0
						rm ${STDERR_T} || die
						break
					else
						eend 1
						eerror "Failed to apply patch ${i/*\//}"
						eerror "Please attach ${STDERR_T} to any bug you may post."
						eshopts_pop
						die "Failed to apply ${i/*\//} on patch depth 1."
					fi
				fi
			fi
			####################################################################

			while [ ${PATCH_DEPTH} -lt 5 ]; do
				echo "Attempting Dry-run:" >> ${STDERR_T}
				echo "cmd: patch -p${PATCH_DEPTH} --no-backup-if-mismatch --dry-run -f < ${i}" >> ${STDERR_T}
				echo "=======================================================" >> ${STDERR_T}
				if [ $(patch -p${PATCH_DEPTH} --no-backup-if-mismatch --dry-run -f < ${i} >> ${STDERR_T}) $? -eq 0 ]; then
					ebegin "Applying ${i/*\//} (-p${PATCH_DEPTH})"
					echo "Attempting patch:" > ${STDERR_T}
					echo "cmd: patch -p${PATCH_DEPTH} --no-backup-if-mismatch -f < ${i}" >> ${STDERR_T}
					echo "=======================================================" >> ${STDERR_T}
					if [ $(patch -p${PATCH_DEPTH} --no-backup-if-mismatch -f < ${i} >> ${STDERR_T}) "$?" -eq 0 ]; then
						eend 0
						rm ${STDERR_T} || die
						break
					else
						eend 1
						eerror "Failed to apply patch ${i/*\//}"
						eerror "Please attach ${STDERR_T} to any bug you may post."
						eshopts_pop
						die "Failed to apply ${i/*\//} on patch depth ${PATCH_DEPTH}."
					fi
				else
					PATCH_DEPTH=$((${PATCH_DEPTH} + 1))
				fi
			done
			if [ ${PATCH_DEPTH} -eq 5 ]; then
				eerror "Failed to dry-run patch ${i/*\//}"
				eerror "Please attach ${STDERR_T} to any bug you may post."
				eshopts_pop
				die "Unable to dry-run patch on any patch depth lower than 5."
			fi
		done
	done

	# When genpatches is used, we want to install 0000_README which documents
	# the patches that were used; such that the user can see them, bug #301478.
	if [[ ! -z ${K_WANT_GENPATCHES} ]] ; then
		UNIPATCH_DOCS="${UNIPATCH_DOCS} 0000_README"
	fi

	# When files listed in UNIPATCH_DOCS are found in KPATCH_DIR's, we copy it
	# to the temporary directory and remember them in UNIPATCH_DOCS to install
	# them during the install phase.
	local tmp
	for x in ${KPATCH_DIR}; do
		for i in ${UNIPATCH_DOCS}; do
			if [[ -f ${x}/${i} ]] ; then
				tmp="${tmp} ${i}"
				cp -f "${x}/${i}" "${T}"/ || die
			fi
		done
	done
	UNIPATCH_DOCS="${tmp}"

	# clean up  KPATCH_DIR's - fixes bug #53610
	for x in ${KPATCH_DIR}; do rm -Rf ${x}; done

	LC_ALL="${myLC_ALL}"
	LANG="${myLANG}"
	eshopts_pop
}

# getfilevar accepts 2 vars as follows:
# getfilevar <VARIABLE> <CONFIGFILE>
# pulled from linux-info

getfilevar() {
	local workingdir basefname basedname xarch=$(tc-arch-kernel)

	if [[ -z ${1} ]] && [[ ! -f ${2} ]]; then
		echo -e "\n"
		eerror "getfilevar requires 2 variables, with the second a valid file."
		eerror "   getfilevar <VARIABLE> <CONFIGFILE>"
	else
		workingdir=${PWD}
		basefname=$(basename ${2})
		basedname=$(dirname ${2})
		unset ARCH

		cd ${basedname}
		echo -e "include ${basefname}\ne:\n\t@echo \$(${1})" | \
			make ${BUILD_FIXES} -s -f - e 2>/dev/null
		cd ${workingdir}

		ARCH=${xarch}
	fi
}

detect_arch() {
	# This function sets ARCH_URI and ARCH_PATCH
	# with the neccessary info for the arch sepecific compatibility
	# patchsets.

	local ALL_ARCH LOOP_ARCH COMPAT_URI i

	# COMPAT_URI is the contents of ${ARCH}_URI
	# ARCH_URI is the URI for all the ${ARCH}_URI patches
	# ARCH_PATCH is ARCH_URI broken into files for UNIPATCH

	ARCH_URI=""
	ARCH_PATCH=""
	ALL_ARCH="ALPHA AMD64 ARM HPPA IA64 M68K MIPS PPC PPC64 S390 SH SPARC X86"

	for LOOP_ARCH in ${ALL_ARCH}; do
		COMPAT_URI="${LOOP_ARCH}_URI"
		COMPAT_URI="${!COMPAT_URI}"

		[[ -n ${COMPAT_URI} ]] && \
			ARCH_URI="${ARCH_URI} $(echo ${LOOP_ARCH} | tr '[:upper:]' '[:lower:]')? ( ${COMPAT_URI} )"

		if [[ ${LOOP_ARCH} == "$(echo $(tc-arch-kernel) | tr '[:lower:]' '[:upper:]')" ]]; 	then
			for i in ${COMPAT_URI}; do
				ARCH_PATCH="${ARCH_PATCH} ${DISTDIR}/${i/*\//}"
			done
		fi
	done
}

headers___fix() {
	# Voodoo to partially fix broken upstream headers.
	# note: do not put inline/asm/volatile together (breaks "inline asm volatile")
	sed -i \
		-e '/^\#define.*_TYPES_H/{:loop n; bloop}' \
		-e 's:\<\([us]\(8\|16\|32\|64\)\)\>:__\1:g' \
		-e "s/\([[:space:]]\)inline\([[:space:](]\)/\1__inline__\2/g" \
		-e "s/\([[:space:]]\)asm\([[:space:](]\)/\1__asm__\2/g" \
		-e "s/\([[:space:]]\)volatile\([[:space:](]\)/\1__volatile__\2/g" \
		"$@"
}

# common functions
#==============================================================
kernel-2_src_unpack() {
	universal_unpack
	debug-print "Doing unipatch"

	# request UNIPATCH_LIST_GENPATCHES in phase since it calls 'use'
	handle_genpatches --set-unipatch-list
	[[ -n ${UNIPATCH_LIST} || -n ${UNIPATCH_LIST_DEFAULT} || -n ${UNIPATCH_LIST_GENPATCHES} ]] && \
		unipatch "${UNIPATCH_LIST_DEFAULT} ${UNIPATCH_LIST_GENPATCHES} ${UNIPATCH_LIST}"

	debug-print "Doing premake"

	# allow ebuilds to massage the source tree after patching but before
	# we run misc `make` functions below
	[[ $(type -t kernel-2_hook_premake) == "function" ]] && kernel-2_hook_premake

	debug-print "Doing epatch_user"
	epatch_user

	debug-print "Doing unpack_set_extraversion"

	[[ -z ${K_NOSETEXTRAVERSION} ]] && unpack_set_extraversion
	unpack_fix_install_path

	# Setup xmakeopts and cd into sourcetree.
	env_setup_xmakeopts
	cd "${S}"

	# We dont need a version.h for anything other than headers
	# at least, I should hope we dont. If this causes problems
	# take out the if/fi block and inform me please.
	# unpack_2_6 should now be 2.6.17 safe anyways
	if [[ ${ETYPE} == headers ]]; then
		kernel_is 2 4 && unpack_2_4
		kernel_is 2 6 && unpack_2_6
	fi

	if [[ $K_DEBLOB_AVAILABLE == 1 ]] && use deblob ; then
		cp "${DISTDIR}/${DEBLOB_A}" "${T}" || die "cp ${DEBLOB_A} failed"
		cp "${DISTDIR}/${DEBLOB_CHECK_A}" "${T}/deblob-check" || die "cp ${DEBLOB_CHECK_A} failed"
		chmod +x "${T}/${DEBLOB_A}" "${T}/deblob-check" || die "chmod deblob scripts failed"
	fi

	# fix a problem on ppc where TOUT writes to /usr/src/linux breaking sandbox
	# only do this for kernel < 2.6.27 since this file does not exist in later
	# kernels
	if [[ -n ${KV_MINOR} &&  ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH} < 2.6.27 ]] ; then
		sed -i \
			-e 's|TOUT      := .tmp_gas_check|TOUT  := $(T).tmp_gas_check|' \
			"${S}"/arch/ppc/Makefile
	else
		sed -i \
			-e 's|TOUT      := .tmp_gas_check|TOUT  := $(T).tmp_gas_check|' \
			"${S}"/arch/powerpc/Makefile
	fi
}

kernel-2_src_compile() {
	cd "${S}"
	[[ ${ETYPE} == headers ]] && compile_headers

	if [[ $K_DEBLOB_AVAILABLE == 1 ]] && use deblob ; then
		echo ">>> Running deblob script ..."
		python_setup
		sh "${T}/${DEBLOB_A}" --force || die "Deblob script failed to run!!!"
	fi
}

# if you leave it to the default src_test, it will run make to
# find whether test/check targets are present; since "make test"
# actually produces a few support files, they are installed even
# though the package is binchecks-restricted.
#
# Avoid this altogether by making the function moot.
kernel-2_src_test() { :; }

kernel-2_pkg_preinst() {
	[[ ${ETYPE} == headers ]] && preinst_headers
}

kernel-2_src_install() {
	install_universal
	[[ ${ETYPE} == headers ]] && install_headers
	[[ ${ETYPE} == sources ]] && install_sources
}

kernel-2_pkg_postinst() {
	[[ ${ETYPE} == sources ]] && postinst_sources
}

kernel-2_pkg_setup() {
	if kernel_is 2 4; then
		if [[ $(gcc-major-version) -ge 4 ]] ; then
			echo
			ewarn "Be warned !! >=sys-devel/gcc-4.0.0 isn't supported with linux-2.4!"
			ewarn "Either switch to another gcc-version (via gcc-config) or use a"
			ewarn "newer kernel that supports gcc-4."
			echo
			ewarn "Also be aware that bugreports about gcc-4 not working"
			ewarn "with linux-2.4 based ebuilds will be closed as INVALID!"
			echo
			epause 10
		fi
	fi

	ABI="${KERNEL_ABI}"
	[[ ${ETYPE} == headers ]] && setup_headers
	[[ ${ETYPE} == sources ]] && echo ">>> Preparing to unpack ..."
}

kernel-2_pkg_postrm() {
	# This warning only makes sense for kernel sources.
	[[ ${ETYPE} == headers ]] && return 0

	# If there isn't anything left behind, then don't complain.
	[[ -e ${EROOT}usr/src/linux-${KV_FULL} ]] || return 0
	echo
	ewarn "Note: Even though you have successfully unmerged "
	ewarn "your kernel package, directories in kernel source location: "
	ewarn "${EROOT}usr/src/linux-${KV_FULL}"
	ewarn "with modified files will remain behind. By design, package managers"
	ewarn "will not remove these modified files and the directories they reside in."
	echo
}
