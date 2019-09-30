# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Diego Pettenò <flameeyes@gentoo.org>

inherit versionator eutils flag-o-matic bsdmk

# Drop patch level from ${PV}
MY_PV=${PV/_p*}
PLEVEL=${PV##*_p}

LICENSE="BSD"
HOMEPAGE="http://www.freebsd.org/"

# Define global package names
LIB="freebsd-lib-${PV}"
BIN="freebsd-bin-${PV}"
CONTRIB="freebsd-contrib-${PV}"
SHARE="freebsd-share-${PV}"
UBIN="freebsd-ubin-${PV}"
USBIN="freebsd-usbin-${PV}"
CRYPTO="freebsd-crypto-${PV}"
LIBEXEC="freebsd-libexec-${PV}"
SBIN="freebsd-sbin-${PV}"
GNU="freebsd-gnu-${PV}"
ETC="freebsd-etc-${PV}"
SYS="freebsd-sys-${PV}"
INCLUDE="freebsd-include-${PV}"
RESCUE="freebsd-rescue-${PV}"
CDDL="freebsd-cddl-${PV}"
SECURE="freebsd-secure-${PV}"

# Release version (5.3, 5.4, 6.0, etc)
RV="$(get_version_component_range 1-2 ${MY_PV})"

# SVN ebuild support.
#   9.1.0.9999 -->	release/9.1.0
#	9.1.9999   -->	releng/9.1
#   9.9999     -->	stable/9
#	9999 -->	head
#
# svn revision can be specified by patch level:
#	freebsd-lib-9.9999_p247000 --> set svn -r 247000

if [[ ${MY_PV} == *9999* ]]; then
	inherit subversion

	# Set SVN revision using patch level.
	[[ ${PV} == *_p* ]] && ESVN_REVISION="${PLEVEL}"

	case ${MY_PV%.9999} in
		*.*.*)	BRANCH="release";;
		*.*)	BRANCH="releng"	;;
		9999)	BRANCH="head"	;;
		*)	    BRANCH="stable"	;;
	esac

	if [[ ${BRANCH} == head ]]  ; then
		SVN_SUB_URI="${BRANCH}"
	else
		SVN_SUB_URI="${BRANCH}/${MY_PV%.9999}"
	fi

	ESVN_REPO_URI="svn://svn.freebsd.org/base/${SVN_SUB_URI}"
	ESVN_PROJECT="freebsd-${BRANCH}"
fi

# Use the original source code.
if [[ ${MY_PV} != *9999* ]] && version_is_at_least 10.0 ${RV} ; then
	DL_PV=${MY_PV/_rc/-RC}
	DL_PV=${DL_PV/_beta/-BETA}
	DL_PV=${DL_PV/_alpha/-ALPHA}
	if [[ ${DL_PV} == ${MY_PV} ]]; then
		DL_PV="${DL_PV}-RELEASE"
	fi
	SRC_URI="mirror://gentoo/freebsd-src-${MY_PV}.tar.xz"
fi

IUSE="profile"

#unalias -a
alias install-info='/usr/bin/bsdinstall-info'

EXPORT_FUNCTIONS src_compile src_install src_unpack

# doperiodic <kind> <file> ...
doperiodic() {
	local kind=$1
	shift

	( # dont want to pollute calling env
		insinto /etc/periodic/${kind}
		insopts -m 0755
		doins "$@"
	)
}

freebsd_get_bmake() {
	local bmake
	bmake=$(get_bmake)
	if version_is_at_least 11.0 ${RV} ; then
		if [[ ${CBUILD} == *-freebsd* ]] ; then
			bmake="${bmake} -m /usr/share/mk/system"
		else
			bmake="${bmake} -m /usr/share/mk/freebsd/system"
		fi
	else
		[[ ${CBUILD} == *-freebsd* ]] || bmake="${bmake} -m /usr/share/mk/freebsd"
	fi

	echo "${bmake}"
}

# Generates SRC_URI or DISTDIR for the upstream patch.
freebsd_upstream_patches() {
	local opt=$1
	[[ ${#UPSTREAM_PATCHES[@]} -eq 0 ]] && return 1
	for x in "${UPSTREAM_PATCHES[@]}"
	do
		local out=${PN}-${x/\//-}
		out=${out/:/}
		if [[ ${opt} == -s ]] ; then
			echo "${DISTDIR}/${out}"
		else
			echo "https://security.freebsd.org/patches/${x} -> ${out}"
		fi
	done
}

freebsd_do_patches() {
	if [[ ${#PATCHES[@]} -gt 1 ]] ; then
		for x in "${PATCHES[@]}"; do
			epatch "${x}"
		done
	else
		for x in ${PATCHES} ; do
			epatch "${x}"
		done
	fi

	# Upstream patches need to be applied on WORKDIR.
	if [[ ${#UPSTREAM_PATCHES[@]} -gt 0 ]] ; then
		cd "${WORKDIR}" || die
		epatch $(freebsd_upstream_patches -s)
		cd "${S}" || die
	fi
	epatch_user
}

freebsd_rename_libraries() {
	ebegin "Renaming libraries"
	# We don't use libtermcap, we use libncurses
	find "${S}" -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-ltermcap:-lncurses:g; s:{LIBTERMCAP}:{LIBNCURSES}:g'
	# flex provides libfl, not libl
	find "${S}" -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-ll$:-lfl:g; s:-ll :-lfl :g; s:{LIBL}:{LIBFL}:g'
	# ncurses provides libncursesw not libcursesw
	find "${S}" -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-lcursesw:-lncursesw:g'
	# we use expat instead of bsdxml
	find "${S}" -name Makefile -print0 | xargs -0 \
		sed -i -e 's:-lbsdxml:-lexpat:g'

	eend $?
}

freebsd_src_unpack() {
	if [[ ${MY_PV} == *9999* ]]; then
		S="${WORKDIR}" subversion_src_unpack

		# When share/mk exists in ${WORKDIR}, BSD's make will try to use it on FreeBSD 10.0 or later.
		# We should remove "${WORKDIR}"/share/mk/*.mk to use /usr/share/mk{,/system}.
		if [[ ${PN} != freebsd-mk-defs ]] ; then
			[[ -e "${WORKDIR}"/share/mk ]] && rm -rf "${WORKDIR}"/share/mk/*.mk
		fi
	else
		if version_is_at_least 10.0 ${RV} ; then
			local tarball="freebsd-src-${MY_PV}.tar.xz"
			local topdir="usr/src/"
			local extractlist=()
			for i in ${EXTRACTONLY} tools/ ; do
				extractlist+=( ${topdir}${i} )
			done
			ebegin "Unpacking parts of ${tarball} to ${WORKDIR}"
			cd "${WORKDIR}" || die
			tar -xJpf "${DISTDIR}/${tarball}" --strip-components=2 "${extractlist[@]}" 2> /dev/null || die "tar extract command failed"
			cd - || die
		else
			for f in ${A} ; do
				[[ ${f} == *.tar.* ]] && unpack ${f}
			done
		fi
	fi
	cd "${S}"

	dummy_mk ${REMOVE_SUBDIRS}

	freebsd_do_patches
	if ! version_is_at_least 11.0 ${RV} ; then
		freebsd_rename_libraries
	fi

	# Starting from FreeBSD 9.2, its install command supports the -l option and
	# they now use it. Emulate it if we are on a system that does not have it.
	if version_is_at_least 9.2 ${RV} && ! has_version '>=sys-freebsd/freebsd-ubin-9.2_beta1' ; then
		export INSTALL_LINK="ln -f"
		export INSTALL_SYMLINK="ln -fs"
	fi
	# An older version of install command doesn't support the -T option.
	if version_is_at_least 11.0 ${RV} && ! has_version ">=sys-freebsd/freebsd-ubin-${RV}" ; then
		export INSTALL="sh ${WORKDIR}/tools/install.sh"
	fi

	# If CC=clang, we should use clang-cpp instead of cpp. #478810, #595878
	if [[ $(tc-getCC) == *clang* ]] ; then
		if type -P clang-cpp > /dev/null ; then
			export CPP=clang-cpp
		else
			mkdir "${WORKDIR}"/workaround_clang-cpp || die "Could not create ${WORKDIR}/workaround_clang-cpp"
			ln -s "$(type -P clang)" "${WORKDIR}"/workaround_clang-cpp/clang-cpp || die "Could not create clang-cpp symlink."
			export CPP="${WORKDIR}/workaround_clang-cpp/clang-cpp"
		fi
	fi

	# Add the special CFLAGS required for multilib support.
	use amd64-fbsd && export CFLAGS_x86_fbsd="${CFLAGS_x86_fbsd} -DCOMPAT_32BIT -B/usr/lib32 -L/usr/lib32"
}

freebsd_src_compile() {
	use profile && filter-flags "-fomit-frame-pointer"
	if version_is_at_least 11.0 ${RV} ; then
		if ! use profile ; then
			mymakeopts="${mymakeopts} WITHOUT_PROFILE= "
		fi
		# Disable the debugging information, use FEATURES=splitdebug instead.
		mymakeopts="${mymakeopts} WITHOUT_DEBUG_FILES= "
		# We don't support test yet.
		mymakeopts="${mymakeopts} WITHOUT_TESTS= "
		# Set the SRCTOP to detect the source directory.
		mymakeopts="${mymakeopts} SRCTOP=${WORKDIR} "
		# Set the common settings.
		mymakeopts="${mymakeopts} WITHOUT_MANCOMPRESS= WITHOUT_INFOCOMPRESS= "
	else
		use profile || mymakeopts="${mymakeopts} NO_PROFILE= "
		mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS= "
	fi

	mymakeopts="${mymakeopts} NO_FSCHG="

	# Make sure to use FreeBSD definitions while crosscompiling
	[[ -z "${BMAKE}" ]] && BMAKE="$(freebsd_get_bmake)"

	# Create objdir if MAKEOBJDIRPREFIX is defined, so that we can make out of
	# tree builds easily.
	if [[ -n "${MAKEOBJDIRPREFIX}" ]] ; then
		mkmake obj || die
	fi

	bsdmk_src_compile "$@"
}

# Helper function to make a multilib build with FreeBSD Makefiles.
# Usage:
# MULTIBUILD_VARIANTS=( $(get_all_abis) )
# multibuild_foreach_variant freebsd_multilib_multibuild_wrapper my_function
#
# Important note: To use this function you _have_ to:
# - inherit multilib.eclass and multibuild.eclass
# - set MULTIBUILD_VARIANTS

freebsd_multilib_multibuild_wrapper() {
	# Get the ABI from multibuild.eclass
	# This assumes MULTIBUILD_VARIANTS contains only valid ABIs.
	local ABI=${MULTIBUILD_VARIANT}

	# First, save the variables: CFLAGS, CXXFLAGS, LDFLAGS, LDADD and mymakeopts.
	for i in CFLAGS CXXFLAGS LDFLAGS LDADD mymakeopts ; do
		export ${i}_SAVE="${!i}"
	done

	# Setup the variables specific to this ABI.
	multilib_toolchain_setup "${ABI}"

	local target="$(tc-arch-kernel ${CHOST})"
	mymakeopts="${mymakeopts} TARGET=${target} MACHINE=${target} MACHINE_ARCH=${target} SHLIBDIR=/usr/$(get_libdir) LIBDIR=/usr/$(get_libdir)"
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		mymakeopts="${mymakeopts} COMPAT_32BIT="
	fi

	einfo "Building for ABI=${ABI} and TARGET=${target}"

	export MAKEOBJDIRPREFIX="${BUILD_DIR}"
	if [ ! -d "${MAKEOBJDIRPREFIX}" ] ; then
		mkdir "${MAKEOBJDIRPREFIX}" || die "Could not create ${MAKEOBJDIRPREFIX}."
	fi

	CTARGET="${CHOST}" "$@"

	# Restore the variables now.
	for i in CFLAGS CXXFLAGS LDFLAGS LDADD mymakeopts ; do
		ii="${i}_SAVE"
		export ${i}="${!ii}"
	done
}

freebsd_src_install() {
	if version_is_at_least 11.0 ${RV} ; then
		if ! use profile ; then
			mymakeopts="${mymakeopts} WITHOUT_PROFILE= "
		fi
		# Disable the debugging information, use FEATURES=splitdebug instead.
		mymakeopts="${mymakeopts} WITHOUT_DEBUG_FILES= "
		# We don't support test yet.
		mymakeopts="${mymakeopts} WITHOUT_TESTS= "
		# Set the SRCTOP to detect the source directory.
		mymakeopts="${mymakeopts} SRCTOP=${WORKDIR} "
		# Set the common settings.
		mymakeopts="${mymakeopts} WITHOUT_MANCOMPRESS= WITHOUT_INFOCOMPRESS= "
	else
		use profile || mymakeopts="${mymakeopts} NO_PROFILE= "
		mymakeopts="${mymakeopts} NO_MANCOMPRESS= NO_INFOCOMPRESS= "
	fi

	mymakeopts="${mymakeopts} NO_FSCHG="

	[[ -z "${BMAKE}" ]] && BMAKE="$(freebsd_get_bmake)"

	bsdmk_src_install "$@"
}
