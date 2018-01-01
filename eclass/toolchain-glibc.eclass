# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: toolchain-glibc.eclass
# @MAINTAINER:
# <toolchain@gentoo.org>
# @BLURB: Common code for sys-libs/glibc ebuilds
# @DESCRIPTION:
# This eclass contains the common phase functions migrated from
# sys-libs/glibc eblits.

if [[ -z ${_TOOLCHAIN_GLIBC_ECLASS} ]]; then

inherit eutils versionator toolchain-funcs flag-o-matic gnuconfig \
	multilib systemd unpacker multiprocessing prefix

case ${EAPI:-0} in
	0|1|2|3) EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_test \
		src_install pkg_preinst pkg_postinst;;
	2|3) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure \
		src_compile src_test src_install pkg_preinst pkg_postinst;;
	4|5) EXPORT_FUNCTIONS pkg_pretend pkg_setup src_unpack src_prepare \
		src_configure src_compile src_test src_install \
		pkg_preinst pkg_postinst;;
	6) EXPORT_FUNCTIONS pkg_pretend;;
	*) die "Unsupported EAPI=${EAPI}";;
esac

# == common ==

alt_prefix() {
	is_crosscompile && echo /usr/${CTARGET}
}

if [[ ${EAPI:-0} == [012] ]] ; then
	: ${ED:=${D}}
	: ${EROOT:=${ROOT}}
fi
# This indirection is for binpkgs. #523332
_nonfatal() { nonfatal "$@" ; }
if [[ ${EAPI:-0} == [0123] ]] ; then
	nonfatal() { "$@" ; }
	_nonfatal() { "$@" ; }
fi

# We need to be able to set alternative headers for
# compiling for non-native platform
# Will also become useful for testing kernel-headers without screwing up
# the whole system.
# note: intentionally undocumented.
alt_headers() {
	echo ${ALT_HEADERS:=$(alt_prefix)/usr/include}
}
alt_build_headers() {
	if [[ -z ${ALT_BUILD_HEADERS} ]] ; then
		ALT_BUILD_HEADERS="${EPREFIX}$(alt_headers)"
		if tc-is-cross-compiler ; then
			ALT_BUILD_HEADERS=${SYSROOT}$(alt_headers)
			if [[ ! -e ${ALT_BUILD_HEADERS}/linux/version.h ]] ; then
				local header_path=$(echo '#include <linux/version.h>' | $(tc-getCPP ${CTARGET}) ${CFLAGS} 2>&1 | grep -o '[^"]*linux/version.h')
				ALT_BUILD_HEADERS=${header_path%/linux/version.h}
			fi
		fi
	fi
	echo "${ALT_BUILD_HEADERS}"
}

alt_libdir() {
	echo $(alt_prefix)/$(get_libdir)
}
alt_usrlibdir() {
	echo $(alt_prefix)/usr/$(get_libdir)
}

builddir() {
	echo "${WORKDIR}/build-${ABI}-${CTARGET}-$1"
}

setup_target_flags() {
	# This largely mucks with compiler flags.  None of which should matter
	# when building up just the headers.
	just_headers && return 0

	case $(tc-arch) in
		x86)
			# -march needed for #185404 #199334
			# TODO: When creating the first glibc cross-compile, this test will
			# always fail as it does a full link which in turn requires glibc.
			# Probably also applies when changing multilib profile settings (e.g.
			# enabling x86 when the profile was amd64-only previously).
			# We could change main to _start and pass -nostdlib here so that we
			# only test the gcc code compilation.  Or we could do a compile and
			# then look for the symbol via scanelf.
			if ! glibc_compile_test "" 'void f(int i, void *p) {if (__sync_fetch_and_add(&i, 1)) f(i, p);}\nint main(){return 0;}\n' 2>/dev/null ; then
				local t=${CTARGET_OPT:-${CTARGET}}
				t=${t%%-*}
				filter-flags '-march=*'
				export CFLAGS="-march=${t} ${CFLAGS}"
				einfo "Auto adding -march=${t} to CFLAGS #185404"
			fi
		;;
		amd64)
			# -march needed for #185404 #199334
			# Note: This test only matters when the x86 ABI is enabled, so we could
			# optimize a bit and elide it.
			# TODO: See cross-compile issues listed above for x86.
			if ! glibc_compile_test "${CFLAGS_x86}" 'void f(int i, void *p) {if (__sync_fetch_and_add(&i, 1)) f(i, p);}\nint main(){return 0;}\n' 2>/dev/null ; then
				local t=${CTARGET_OPT:-${CTARGET}}
				t=${t%%-*}
				# Normally the target is x86_64-xxx, so turn that into the -march that
				# gcc actually accepts. #528708
				[[ ${t} == "x86_64" ]] && t="x86-64"
				filter-flags '-march=*'
				# ugly, ugly, ugly.  ugly.
				CFLAGS_x86=$(CFLAGS=${CFLAGS_x86} filter-flags '-march=*'; echo "${CFLAGS}")
				export CFLAGS_x86="${CFLAGS_x86} -march=${t}"
				einfo "Auto adding -march=${t} to CFLAGS_x86 #185404"
			fi
		;;
		mips)
			# The mips abi cannot support the GNU style hashes. #233233
			filter-ldflags -Wl,--hash-style=gnu -Wl,--hash-style=both
		;;
		sparc)
			# Both sparc and sparc64 can use -fcall-used-g6.  -g7 is bad, though.
			filter-flags "-fcall-used-g7"
			append-flags "-fcall-used-g6"

			# If the CHOST is the basic one (e.g. not sparcv9-xxx already),
			# try to pick a better one so glibc can use cpu-specific .S files.
			# We key off the CFLAGS to get a good value.  Also need to handle
			# version skew.
			# We can't force users to set their CHOST to their exact machine
			# as many of these are not recognized by config.sub/gcc and such :(.
			# Note: If the mcpu values don't scale, we might try probing CPP defines.
			# Note: Should we factor in -Wa,-AvXXX flags too ?  Or -mvis/etc... ?

			local cpu
			case ${CTARGET} in
			sparc64-*)
				case $(get-flag mcpu) in
				niagara[234])
					if version_is_at_least 2.8 ; then
						cpu="sparc64v2"
					elif version_is_at_least 2.4 ; then
						cpu="sparc64v"
					elif version_is_at_least 2.2.3 ; then
						cpu="sparc64b"
					fi
					;;
				niagara)
					if version_is_at_least 2.4 ; then
						cpu="sparc64v"
					elif version_is_at_least 2.2.3 ; then
						cpu="sparc64b"
					fi
					;;
				ultrasparc3)
					cpu="sparc64b"
					;;
				*)
					# We need to force at least v9a because the base build doesn't
					# work with just v9.
					# https://sourceware.org/bugzilla/show_bug.cgi?id=19477
					[[ -z ${cpu} ]] && append-flags "-Wa,-xarch=v9a"
					;;
				esac
				;;
			sparc-*)
				case $(get-flag mcpu) in
				niagara[234])
					if version_is_at_least 2.8 ; then
						cpu="sparcv9v2"
					elif version_is_at_least 2.4 ; then
						cpu="sparcv9v"
					elif version_is_at_least 2.2.3 ; then
						cpu="sparcv9b"
					else
						cpu="sparcv9"
					fi
					;;
				niagara)
					if version_is_at_least 2.4 ; then
						cpu="sparcv9v"
					elif version_is_at_least 2.2.3 ; then
						cpu="sparcv9b"
					else
						cpu="sparcv9"
					fi
					;;
				ultrasparc3)
					cpu="sparcv9b"
					;;
				v9|ultrasparc)
					cpu="sparcv9"
					;;
				v8|supersparc|hypersparc|leon|leon3)
					cpu="sparcv8"
					;;
				esac
			;;
			esac
			[[ -n ${cpu} ]] && CTARGET_OPT="${cpu}-${CTARGET#*-}"
		;;
	esac
}

setup_flags() {
	# Make sure host make.conf doesn't pollute us
	if is_crosscompile || tc-is-cross-compiler ; then
		CHOST=${CTARGET} strip-unsupported-flags
	fi

	# Store our CFLAGS because it's changed depending on which CTARGET
	# we are building when pulling glibc on a multilib profile
	CFLAGS_BASE=${CFLAGS_BASE-${CFLAGS}}
	CFLAGS=${CFLAGS_BASE}
	CXXFLAGS_BASE=${CXXFLAGS_BASE-${CXXFLAGS}}
	CXXFLAGS=${CXXFLAGS_BASE}
	ASFLAGS_BASE=${ASFLAGS_BASE-${ASFLAGS}}
	ASFLAGS=${ASFLAGS_BASE}

	# Over-zealous CFLAGS can often cause problems.  What may work for one
	# person may not work for another.  To avoid a large influx of bugs
	# relating to failed builds, we strip most CFLAGS out to ensure as few
	# problems as possible.
	strip-flags
	strip-unsupported-flags
	filter-flags -m32 -m64 -mabi=*

	# Bug 492892.
	filter-flags -frecord-gcc-switches

	unset CBUILD_OPT CTARGET_OPT
	if use multilib ; then
		CTARGET_OPT=$(get_abi_CTARGET)
		[[ -z ${CTARGET_OPT} ]] && CTARGET_OPT=$(get_abi_CHOST)
	fi

	setup_target_flags

	if [[ -n ${CTARGET_OPT} && ${CBUILD} == ${CHOST} ]] && ! is_crosscompile; then
		CBUILD_OPT=${CTARGET_OPT}
	fi

	# Lock glibc at -O2 -- linuxthreads needs it and we want to be
	# conservative here.  -fno-strict-aliasing is to work around #155906
	filter-flags -O?
	append-flags -O2 -fno-strict-aliasing

	# Can't build glibc itself with fortify code.  Newer versions add
	# this flag for us, so no need to do it manually.
	version_is_at_least 2.16 ${PV} || append-cppflags -U_FORTIFY_SOURCE

	# building glibc <2.25 with SSP is fraught with difficulty, especially
	# due to __stack_chk_fail_local which would mean significant changes
	# to the glibc build process. See bug #94325 #293721
	# Note we have to handle both user-given CFLAGS and gcc defaults via
	# spec rules here.  We can't simply add -fno-stack-protector as it gets
	# added before user flags, and we can't just filter-flags because
	# _filter_hardened doesn't support globs.
	filter-flags -fstack-protector*
	if ! version_is_at_least 2.25 ; then
		tc-enables-ssp && append-flags $(test-flags -fno-stack-protector)
	fi

	if [[ $(gcc-major-version) -lt 6 ]]; then
		# Starting with gcc-6 (and fully upstreamed pie patches) we control
		# default enabled/disabled pie via use flags. So nothing to do
		# here. #618160

		if use hardened && tc-enables-pie ; then
			# Force PIC macro definition for all compilations since they're all
			# either -fPIC or -fPIE with the default-PIE compiler.
			append-cppflags -DPIC
		else
			# Don't build -fPIE without the default-PIE compiler and the
			# hardened-pie patch
			filter-flags -fPIE
		fi
	fi
}

want_nptl() {
	[[ -z ${LT_VER} ]] && return 0
	want_tls || return 1
	use nptl || return 1

	# Older versions of glibc had incomplete arch support for nptl.
	# But if you're building those now, you can handle USE=nptl yourself.
	return 0
}

want_linuxthreads() {
	[[ -z ${LT_VER} ]] && return 1
	use linuxthreads
}

want_tls() {
	# Archs that can use TLS (Thread Local Storage)
	case $(tc-arch) in
		x86)
			# requires i486 or better #106556
			[[ ${CTARGET} == i[4567]86* ]] && return 0
			return 1
		;;
	esac

	return 0
}

want__thread() {
	want_tls || return 1

	# For some reason --with-tls --with__thread is causing segfaults on sparc32.
	[[ ${PROFILE_ARCH} == "sparc" ]] && return 1

	[[ -n ${WANT__THREAD} ]] && return ${WANT__THREAD}

	# only test gcc -- can't test linking yet
	tc-has-tls -c ${CTARGET}
	WANT__THREAD=$?

	return ${WANT__THREAD}
}

use_multiarch() {
	# Make sure binutils is new enough to support indirect functions #336792
	# This funky sed supports gold and bfd linkers.
	local bver nver
	bver=$($(tc-getLD ${CTARGET}) -v | sed -n -r '1{s:[^0-9]*::;s:^([0-9.]*).*:\1:;p}')
	case $(tc-arch ${CTARGET}) in
	amd64|x86) nver="2.20" ;;
	arm)       nver="2.22" ;;
	hppa)      nver="2.23" ;;
	ppc|ppc64) nver="2.20" ;;
	# ifunc was added in 2.23, but glibc also needs machinemode which is in 2.24.
	s390)      nver="2.24" ;;
	sparc)     nver="2.21" ;;
	*)         return 1 ;;
	esac
	version_is_at_least ${nver} ${bver}
}

# Setup toolchain variables that had historically
# been defined in the profiles for these archs.
setup_env() {
	# silly users
	unset LD_RUN_PATH
	unset LD_ASSUME_KERNEL

	if is_crosscompile || tc-is-cross-compiler ; then
		multilib_env ${CTARGET_OPT:-${CTARGET}}

		if ! use multilib ; then
			MULTILIB_ABIS=${DEFAULT_ABI}
		else
			MULTILIB_ABIS=${MULTILIB_ABIS:-${DEFAULT_ABI}}
		fi

		# If the user has CFLAGS_<CTARGET> in their make.conf, use that,
		# and fall back on CFLAGS.
		local VAR=CFLAGS_${CTARGET//[-.]/_}
		CFLAGS=${!VAR-${CFLAGS}}
	fi

	setup_flags

	export ABI=${ABI:-${DEFAULT_ABI:-default}}

	local VAR=CFLAGS_${ABI}
	# We need to export CFLAGS with abi information in them because glibc's
	# configure script checks CFLAGS for some targets (like mips).  Keep
	# around the original clean value to avoid appending multiple ABIs on
	# top of each other.
	: ${__GLIBC_CC:=$(tc-getCC ${CTARGET_OPT:-${CTARGET}})}
	export __GLIBC_CC CC="${__GLIBC_CC} ${!VAR}"
}

foreach_abi() {
	setup_env

	local ret=0
	local abilist=""
	if use multilib ; then
		abilist=$(get_install_abis)
	else
		abilist=${DEFAULT_ABI}
	fi
	local -x ABI
	for ABI in ${abilist:-default} ; do
		setup_env
		einfo "Running $1 for ABI ${ABI}"
		$1
		: $(( ret |= $? ))
	done
	return ${ret}
}

just_headers() {
	is_crosscompile && use crosscompile_opts_headers-only
}

glibc_banner() {
	local b="Gentoo ${PVR}"
	[[ -n ${SNAP_VER} ]] && b+=" snapshot ${SNAP_VER}"
	[[ -n ${BRANCH_UPDATE} ]] && b+=" branch ${BRANCH_UPDATE}"
	[[ -n ${PATCH_VER} ]] && ! use vanilla && b+=" p${PATCH_VER}"
	echo "${b}"
}

# == phases ==

glibc_compile_test() {
	local ret save_cflags=${CFLAGS}
	CFLAGS+=" $1"
	shift

	pushd "${T}" >/dev/null

	rm -f glibc-test*
	printf '%b' "$*" > glibc-test.c

	_nonfatal emake -s glibc-test
	ret=$?

	popd >/dev/null

	CFLAGS=${save_cflags}
	return ${ret}
}

glibc_run_test() {
	local ret

	if [[ ${EMERGE_FROM} == "binary" ]] ; then
		# ignore build failures when installing a binary package #324685
		glibc_compile_test "" "$@" 2>/dev/null || return 0
	else
		if ! glibc_compile_test "" "$@" ; then
			ewarn "Simple build failed ... assuming this is desired #324685"
			return 0
		fi
	fi

	pushd "${T}" >/dev/null

	./glibc-test
	ret=$?
	rm -f glibc-test*

	popd >/dev/null

	return ${ret}
}

check_devpts() {
	# Make sure devpts is mounted correctly for use w/out setuid pt_chown.

	# If merely building the binary package, then there's nothing to verify.
	[[ ${MERGE_TYPE} == "buildonly" ]] && return

	# Only sanity check when installing the native glibc.
	[[ ${ROOT} != "/" ]] && return

	# Older versions always installed setuid, so no need to check.
	in_iuse suid || return

	# If they're opting in to the old suid code, then no need to check.
	use suid && return

	if awk '$3 == "devpts" && $4 ~ /[, ]gid=5[, ]/ { exit 1 }' /proc/mounts ; then
		eerror "In order to use glibc with USE=-suid, you must make sure that"
		eerror "you have devpts mounted at /dev/pts with the gid=5 option."
		eerror "Openrc should do this for you, so you should check /etc/fstab"
		eerror "and make sure you do not have any invalid settings there."
		# Do not die on older kernels as devpts did not export these settings #489520.
		if version_is_at_least 2.6.25 $(uname -r) ; then
			die "mount & fix your /dev/pts settings"
		fi
	fi
}

toolchain-glibc_pkg_pretend() {
	if [[ ${EAPI:-0} == 6 ]]; then
		eerror "We're moving code back to the ebuilds to get away from the ancient EAPI cruft."
		eerror "From EAPI=6 on you'll have to define the phases in the glibc ebuilds."
		die "Silly overlay authors..."
	fi

	# For older EAPIs, this is run in pkg_preinst.
	if [[ ${EAPI:-0} != [0123] ]] ; then
		check_devpts
	fi

	# Prevent native builds from downgrading.
	if [[ ${MERGE_TYPE} != "buildonly" ]] && \
	   [[ ${ROOT} == "/" ]] && \
	   [[ ${CBUILD} == ${CHOST} ]] && \
	   [[ ${CHOST} == ${CTARGET} ]] ; then
		# The high rev # is to allow people to downgrade between -r# versions.
		# We want to block 2.20->2.19, but 2.20-r3->2.20-r2 should be fine.
		# Hopefully we never actually use a r# this high.
		if has_version ">${CATEGORY}/${P}-r10000" ; then
			eerror "Sanity check to keep you from breaking your system:"
			eerror " Downgrading glibc is not supported and a sure way to destruction"
			die "aborting to save your system"
		fi

		if ! glibc_run_test '#include <pwd.h>\nint main(){return getpwuid(0)==0;}\n'
		then
			eerror "Your patched vendor kernel is broken.  You need to get an"
			eerror "update from whoever is providing the kernel to you."
			eerror "https://sourceware.org/bugzilla/show_bug.cgi?id=5227"
			eerror "http://bugs.gentoo.org/262698"
			die "keeping your system alive, say thank you"
		fi

		if ! glibc_run_test '#include <unistd.h>\n#include <sys/syscall.h>\nint main(){return syscall(1000)!=-1;}\n'
		then
			eerror "Your old kernel is broken.  You need to update it to"
			eerror "a newer version as syscall(<bignum>) will break."
			eerror "http://bugs.gentoo.org/279260"
			die "keeping your system alive, say thank you"
		fi
	fi

	# users have had a chance to phase themselves, time to give em the boot
	if [[ -e ${EROOT}/etc/locale.gen ]] && [[ -e ${EROOT}/etc/locales.build ]] ; then
		eerror "You still haven't deleted ${EROOT}/etc/locales.build."
		eerror "Do so now after making sure ${EROOT}/etc/locale.gen is kosher."
		die "lazy upgrader detected"
	fi

	if [[ ${CTARGET} == i386-* ]] ; then
		eerror "i386 CHOSTs are no longer supported."
		eerror "Chances are you don't actually want/need i386."
		eerror "Please read http://www.gentoo.org/doc/en/change-chost.xml"
		die "please fix your CHOST"
	fi

	if [[ -e /proc/xen ]] && [[ $(tc-arch) == "x86" ]] && ! is-flag -mno-tls-direct-seg-refs ; then
		ewarn "You are using Xen but don't have -mno-tls-direct-seg-refs in your CFLAGS."
		ewarn "This will result in a 50% performance penalty when running with a 32bit"
		ewarn "hypervisor, which is probably not what you want."
	fi

	use hardened && ! tc-enables-pie && \
		ewarn "PIE hardening not applied, as your compiler doesn't default to PIE"

	# Make sure host system is up to date #394453
	if has_version '<sys-libs/glibc-2.13' && \
	   [[ -n $(scanelf -qys__guard -F'#s%F' "${EROOT}"/lib*/l*-*.so) ]]
	then
		ebegin "Scanning system for __guard to see if you need to rebuild first ..."
		local files=$(
			scanelf -qys__guard -F'#s%F' \
				"${EROOT}"/*bin/ \
				"${EROOT}"/lib* \
				"${EROOT}"/usr/*bin/ \
				"${EROOT}"/usr/lib* | \
				egrep -v \
					-e "^${EROOT}/lib.*/(libc|ld)-2.*.so$" \
					-e "^${EROOT}/sbin/(ldconfig|sln)$"
		)
		[[ -z ${files} ]]
		if ! eend $? ; then
			eerror "Your system still has old SSP __guard symbols.  You need to"
			eerror "rebuild all the packages that provide these files first:"
			eerror "${files}"
			die "old __guard detected"
		fi
	fi
}

toolchain-glibc_pkg_setup() {
	[[ ${EAPI:-0} == [0123] ]] && toolchain-glibc_pkg_pretend
}

int_to_KV() {
	local version=$1 major minor micro
	major=$((version / 65536))
	minor=$(((version % 65536) / 256))
	micro=$((version % 256))
	echo ${major}.${minor}.${micro}
}

eend_KV() {
	[[ $(KV_to_int $1) -ge $(KV_to_int $2) ]]
	eend $?
}

get_kheader_version() {
	printf '#include <linux/version.h>\nLINUX_VERSION_CODE\n' | \
	$(tc-getCPP ${CTARGET}) -I "${EPREFIX}/$(alt_build_headers)" - | \
	tail -n 1
}

check_nptl_support() {
	# don't care about the compiler here as we aren't using it
	just_headers && return

	local run_kv build_kv want_kv
	run_kv=$(int_to_KV $(get_KV))
	build_kv=$(int_to_KV $(get_kheader_version))
	want_kv=${NPTL_KERN_VER}

	ebegin "Checking gcc for __thread support"
	if ! eend $(want__thread ; echo $?) ; then
		echo
		eerror "Could not find a gcc that supports the __thread directive!"
		eerror "Please update your binutils/gcc and try again."
		die "No __thread support in gcc!"
	fi

	if ! is_crosscompile && ! tc-is-cross-compiler ; then
		# Building fails on an non-supporting kernel
		ebegin "Checking kernel version (${run_kv} >= ${want_kv})"
		if ! eend_KV ${run_kv} ${want_kv} ; then
			echo
			eerror "You need a kernel of at least ${want_kv} for NPTL support!"
			die "Kernel version too low!"
		fi
	fi

	ebegin "Checking linux-headers version (${build_kv} >= ${want_kv})"
	if ! eend_KV ${build_kv} ${want_kv} ; then
		echo
		eerror "You need linux-headers of at least ${want_kv} for NPTL support!"
		die "linux-headers version too low!"
	fi
}

unpack_pkg() {
	local a=${PN}
	[[ -n ${SNAP_VER} ]] && a="${a}-${RELEASE_VER}"
	[[ -n $1 ]] && a="${a}-$1"
	if [[ -n ${SNAP_VER} ]] ; then
		a="${a}-${SNAP_VER}"
	else
		if [[ -n $2 ]] ; then
			a="${a}-$2"
		else
			a="${a}-${RELEASE_VER}"
		fi
	fi
	if has ${a}.tar.xz ${A} ; then
		unpacker ${a}.tar.xz
	else
		unpack ${a}.tar.bz2
	fi
	[[ -n $1 ]] && { mv ${a} $1 || die ; }
}

toolchain-glibc_do_src_unpack() {
	# Check NPTL support _before_ we unpack things to save some time
	want_nptl && check_nptl_support

	if [[ -n ${EGIT_REPO_URIS} ]] ; then
		local i d
		for ((i=0; i<${#EGIT_REPO_URIS[@]}; ++i)) ; do
			EGIT_REPO_URI=${EGIT_REPO_URIS[$i]}
			EGIT_SOURCEDIR=${EGIT_SOURCEDIRS[$i]}
			git-2_src_unpack
		done
	else
		unpack_pkg
	fi

	cd "${S}"
	touch locale/C-translit.h #185476 #218003
	[[ -n ${LT_VER}     ]] && unpack_pkg linuxthreads ${LT_VER}
	[[ -n ${PORTS_VER}  ]] && unpack_pkg ports ${PORTS_VER}
	[[ -n ${LIBIDN_VER} ]] && unpack_pkg libidn

	if [[ -n ${PATCH_VER} ]] ; then
		cd "${WORKDIR}"
		unpack glibc-${RELEASE_VER}-patches-${PATCH_VER}.tar.bz2
		# pull out all the addons
		local d
		for d in extra/*/configure ; do
			d=${d%/configure}
			[[ -d ${S}/${d} ]] && die "${d} already exists in \${S}"
			mv "${d}" "${S}" || die "moving ${d} failed"
		done
	fi
}

toolchain-glibc_src_unpack() {
	setup_env

	toolchain-glibc_do_src_unpack
	[[ ${EAPI:-0} == [01] ]] && cd "${S}" && toolchain-glibc_src_prepare
}

toolchain-glibc_src_prepare() {
	# XXX: We should do the branchupdate, before extracting the manpages and
	# infopages else it does not help much (mtimes change if there is a change
	# to them with branchupdate)
	if [[ -n ${BRANCH_UPDATE} ]] ; then
		epatch "${DISTDIR}"/glibc-${RELEASE_VER}-branch-update-${BRANCH_UPDATE}.patch.bz2

		# Snapshot date patch
		einfo "Patching version to display snapshot date ..."
		sed -i -e "s:\(#define RELEASE\).*:\1 \"${BRANCH_UPDATE}\":" version.h
	fi

	# tag, glibc is it
	if ! version_is_at_least 2.17 ; then
		[[ -e csu/Banner ]] && die "need new banner location"
		glibc_banner > csu/Banner
	fi
	if [[ -n ${PATCH_VER} ]] && ! use vanilla ; then
		EPATCH_MULTI_MSG="Applying Gentoo Glibc Patchset ${RELEASE_VER}-${PATCH_VER} ..." \
		EPATCH_EXCLUDE=${GLIBC_PATCH_EXCLUDE} \
		EPATCH_SUFFIX="patch" \
		ARCH=$(tc-arch) \
		epatch "${WORKDIR}"/patches
	fi

	if just_headers ; then
		if [[ -e ports/sysdeps/mips/preconfigure ]] ; then
			# mips peeps like to screw with us.  if building headers,
			# we don't have a real compiler, so we can't let them
			# insert -mabi on us.
			sed -i '/CPPFLAGS=.*-mabi/s|.*|:|' ports/sysdeps/mips/preconfigure || die
			find ports/sysdeps/mips/ -name Makefile -exec sed -i '/^CC.*-mabi=/s:-mabi=.*:-D_MIPS_SZPTR=32:' {} +
		fi
	fi

	epatch_user

	gnuconfig_update

	# Glibc is stupid sometimes, and doesn't realize that with a
	# static C-Only gcc, -lgcc_eh doesn't exist.
	# https://sourceware.org/ml/libc-alpha/2003-09/msg00100.html
	# https://sourceware.org/ml/libc-alpha/2005-02/msg00042.html
	# But! Finally fixed in recent versions:
	# https://sourceware.org/ml/libc-alpha/2012-05/msg01865.html
	if ! version_is_at_least 2.16 ; then
		echo 'int main(){}' > "${T}"/gcc_eh_test.c
		if ! $(tc-getCC ${CTARGET}) ${CFLAGS} ${LDFLAGS} "${T}"/gcc_eh_test.c -lgcc_eh 2>/dev/null ; then
			sed -i -e 's:-lgcc_eh::' Makeconfig || die "sed gcc_eh"
		fi
	fi

	cd "${WORKDIR}"
	find . -type f '(' -size 0 -o -name "*.orig" ')' -delete
	find . -name configure -exec touch {} +

	eprefixify extra/locale/locale-gen

	# Fix permissions on some of the scripts.
	chmod u+x "${S}"/scripts/*.sh
}
dump_toolchain_settings() {
	echo

	einfo "$*"

	local v
	for v in ABI CBUILD CHOST CTARGET CBUILD_OPT CTARGET_OPT CC LD {AS,C,CPP,CXX,LD}FLAGS ; do
		einfo " $(printf '%15s' ${v}:)   ${!v}"
	done

	# The glibc configure script doesn't properly use LDFLAGS all the time.
	export CC="$(tc-getCC ${CTARGET}) ${LDFLAGS}"
	einfo " $(printf '%15s' 'Manual CC:')   ${CC}"
	echo
}

glibc_do_configure() {
	# Glibc does not work with gold (for various reasons) #269274.
	tc-ld-disable-gold

	dump_toolchain_settings "Configuring glibc for $1"

	local myconf=()

	# set addons
	pushd "${S}" > /dev/null
	local addons=$(echo */configure | sed \
		-e 's:/configure::g' \
		-e 's:\(linuxthreads\|nptl\|rtkaio\|glibc-compat\)\( \|$\)::g' \
		-e 's: \+$::' \
		-e 's! !,!g' \
		-e 's!^!,!' \
		-e '/^,\*$/d')
	[[ -d ports ]] && addons+=",ports"
	popd > /dev/null

	if has_version '<sys-libs/glibc-2.13' ; then
		myconf+=( --enable-old-ssp-compat )
	fi

	if version_is_at_least 2.25 ; then
		case ${CTARGET} in
			mips*)
				# dlopen() detects stack smash on mips n32 ABI.
				# Cause is unknown: https://bugs.gentoo.org/640130
				myconf+=( --enable-stack-protector=no )
				;;
			powerpc-*)
				# Currently gcc on powerpc32 generates invalid code for
				# __builtin_return_address(0) calls. Normally programs
				# don't do that but malloc hooks in glibc do:
				# https://gcc.gnu.org/PR81996
				# https://bugs.gentoo.org/629054
				myconf+=( --enable-stack-protector=no )
				;;
			*)
				myconf+=( --enable-stack-protector=all )
				;;
		esac
	fi

	# Keep a whitelist of targets supporing IFUNC. glibc's ./configure
	# is not robust enough to detect proper support:
	#    https://bugs.gentoo.org/641216
	#    https://sourceware.org/PR22634#c0
	case $(tc-arch ${CTARGET}) in
		# Keep whitelist of targets where autodetection mostly works.
		amd64|x86|sparc|ppc|ppc64|arm|arm64|s390) ;;
		# Blacklist everywhere else
		*) myconf+=( libc_cv_ld_gnu_indirect_function=no ) ;;
	esac

	if version_is_at_least 2.25 ; then
		myconf+=( --enable-stackguard-randomization )
	else
		myconf+=( $(use_enable hardened stackguard-randomization) )
	fi

	[[ $(tc-is-softfloat) == "yes" ]] && myconf+=( --without-fp )

	if [[ $1 == "linuxthreads" ]] ; then
		if want_tls ; then
			myconf+=( --with-tls )

			if ! want__thread || use glibc-compat20 || [[ ${LT_KER_VER} == 2.[02].* ]] ; then
				myconf+=( --without-__thread )
			else
				myconf+=( --with-__thread )
			fi
		else
			myconf+=( --without-tls --without-__thread )
		fi

		myconf+=( --disable-sanity-checks )
		addons="linuxthreads${addons}"
		myconf+=( --enable-kernel=${LT_KER_VER} )
	elif [[ $1 == "nptl" ]] ; then
		# Newer versions require nptl, so there is no addon for it.
		version_is_at_least 2.20 || addons="nptl${addons}"
		myconf+=( --enable-kernel=${NPTL_KERN_VER} )
	else
		die "invalid pthread option"
	fi
	myconf+=( --enable-add-ons="${addons#,}" )

	# Since SELinux support is only required for nscd, only enable it if:
	# 1. USE selinux
	# 2. only for the primary ABI on multilib systems
	# 3. Not a crosscompile
	if ! is_crosscompile && use selinux ; then
		if use multilib ; then
			if is_final_abi ; then
				myconf+=( --with-selinux )
			else
				myconf+=( --without-selinux )
			fi
		else
			myconf+=( --with-selinux )
		fi
	else
		myconf+=( --without-selinux )
	fi

	# Force a few tests where we always know the answer but
	# configure is incapable of finding it.
	if is_crosscompile ; then
		export \
			libc_cv_c_cleanup=yes \
			libc_cv_forced_unwind=yes
	fi

	myconf+=(
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		$(use_enable profile)
		$(use_with gd)
		--with-headers=$(alt_build_headers)
		--prefix="${EPREFIX}/usr"
		--sysconfdir="${EPREFIX}/etc"
		--localstatedir="${EPREFIX}/var"
		--libdir='$(prefix)'/$(get_libdir)
		--mandir='$(prefix)'/share/man
		--infodir='$(prefix)'/share/info
		--libexecdir='$(libdir)'/misc/glibc
		--with-bugurl=http://bugs.gentoo.org/
		--with-pkgversion="$(glibc_banner)"
		$(use_multiarch || echo --disable-multi-arch)
		$(in_iuse rpc && use_enable rpc obsolete-rpc || echo --enable-obsolete-rpc)
		$(in_iuse systemtap && use_enable systemtap)
		$(in_iuse nscd && use_enable nscd)
		${EXTRA_ECONF}
	)

	# We rely on sys-libs/timezone-data for timezone tools normally.
	if version_is_at_least 2.23 ; then
		myconf+=( $(use_enable vanilla timezone-tools) )
	fi

	# These libs don't have configure flags.
	ac_cv_lib_audit_audit_log_user_avc_message=$(in_iuse audit && usex audit || echo no)
	ac_cv_lib_cap_cap_init=$(in_iuse caps && usex caps || echo no)

	# There is no configure option for this and we need to export it
	# since the glibc build will re-run configure on itself
	export libc_cv_rootsbindir="${EPREFIX}/sbin"
	export libc_cv_slibdir="${EPREFIX}/$(get_libdir)"

	# We take care of patching our binutils to use both hash styles,
	# and many people like to force gnu hash style only, so disable
	# this overriding check.  #347761
	export libc_cv_hashstyle=no

	# Overtime, generating info pages can be painful.  So disable this for
	# versions older than the latest stable to avoid the issue (this ver
	# should be updated from time to time).  #464394 #465816
	if ! version_is_at_least 2.17 ; then
		export ac_cv_prog_MAKEINFO=:
	fi

	local builddir=$(builddir "$1")
	mkdir -p "${builddir}"
	cd "${builddir}"
	set -- "${S}"/configure "${myconf[@]}"
	echo "$@"
	"$@" || die "failed to configure glibc"

	# ia64 static cross-compilers are a pita in so much that they
	# can't produce static ELFs (as the libgcc.a is broken).  so
	# disable building of the programs for those targets if it
	# doesn't work.
	# XXX: We could turn this into a compiler test, but ia64 is
	# the only one that matters, so this should be fine for now.
	if is_crosscompile && [[ ${CTARGET} == ia64* ]] ; then
		sed -i '1i+link-static = touch $@' config.make
	fi

	# If we're trying to migrate between ABI sets, we need
	# to lie and use a local copy of gcc.  Like if the system
	# is built with MULTILIB_ABIS="amd64 x86" but we want to
	# add x32 to it, gcc/glibc don't yet support x32.
	if [[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib ; then
		echo 'main(){}' > "${T}"/test.c
		if ! $(tc-getCC ${CTARGET}) ${CFLAGS} ${LDFLAGS} "${T}"/test.c -Wl,-emain -lgcc 2>/dev/null ; then
			sed -i -e '/^CC = /s:$: -B$(objdir)/../'"gcc-${GCC_BOOTSTRAP_VER}/${ABI}:" config.make || die
			mkdir -p sunrpc
			cp $(which rpcgen) sunrpc/cross-rpcgen || die
			touch -t 202001010101 sunrpc/cross-rpcgen || die
		fi
	fi
}

toolchain-glibc_headers_configure() {
	export ABI=default

	local builddir=$(builddir "headers")
	mkdir -p "${builddir}"
	cd "${builddir}"

	# if we don't have a compiler yet, we can't really test it now ...
	# hopefully they don't affect header generation, so let's hope for
	# the best here ...
	local v vars=(
		ac_cv_header_cpuid_h=yes
		libc_cv_{386,390,alpha,arm,hppa,ia64,mips,{powerpc,sparc}{,32,64},sh,x86_64}_tls=yes
		libc_cv_asm_cfi_directives=yes
		libc_cv_broken_visibility_attribute=no
		libc_cv_c_cleanup=yes
		libc_cv_forced_unwind=yes
		libc_cv_gcc___thread=yes
		libc_cv_mlong_double_128=yes
		libc_cv_mlong_double_128ibm=yes
		libc_cv_ppc_machine=yes
		libc_cv_ppc_rel16=yes
		libc_cv_predef_fortify_source=no
		libc_cv_visibility_attribute=yes
		libc_cv_z_combreloc=yes
		libc_cv_z_execstack=yes
		libc_cv_z_initfirst=yes
		libc_cv_z_nodelete=yes
		libc_cv_z_nodlopen=yes
		libc_cv_z_relro=yes
		libc_mips_abi=${ABI}
		libc_mips_float=$([[ $(tc-is-softfloat) == "yes" ]] && echo soft || echo hard)
		# These libs don't have configure flags.
		ac_cv_lib_audit_audit_log_user_avc_message=no
		ac_cv_lib_cap_cap_init=no
	)
	if ! version_is_at_least 2.25 ; then
		vars+=(
			libc_cv_predef_stack_protector=no
		)
	fi
	einfo "Forcing cached settings:"
	for v in "${vars[@]}" ; do
		einfo " ${v}"
		export ${v}
	done

	# Blow away some random CC settings that screw things up. #550192
	if [[ -d ${S}/sysdeps/mips ]]; then
		pushd "${S}"/sysdeps/mips >/dev/null
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=32:' mips32/Makefile mips64/n32/Makefile || die
		sed -i -e '/^CC +=/s:=.*:= -D_MIPS_SZPTR=64:' mips64/n64/Makefile || die
		if version_is_at_least 2.21 ; then
			# Force the mips ABI to the default.  This is OK because the set of
			# installed headers in this phase is the same between the 3 ABIs.
			# If this ever changes, this hack will break, but that's unlikely
			# as glibc discourages that behavior.
			# https://crbug.com/647033
			sed -i -e 's:abiflag=.*:abiflag=_ABIO32:' preconfigure || die
		fi
		popd >/dev/null
	fi

	local myconf=()
	myconf+=(
		--disable-sanity-checks
		--enable-hacker-mode
		--without-cvs
		--disable-werror
		--enable-bind-now
		--build=${CBUILD_OPT:-${CBUILD}}
		--host=${CTARGET_OPT:-${CTARGET}}
		--with-headers=$(alt_build_headers)
		--prefix="${EPREFIX}/usr"
		${EXTRA_ECONF}
	)

	local addons
	[[ -d ${S}/ports ]] && addons+=",ports"
	# Newer versions require nptl, so there is no addon for it.
	version_is_at_least 2.20 || addons+=",nptl"
	myconf+=( --enable-add-ons="${addons#,}" )

	# Nothing is compiled here which would affect the headers for the target.
	# So forcing CC/CFLAGS is sane.
	set -- "${S}"/configure "${myconf[@]}"
	echo "$@"
	CC="$(tc-getBUILD_CC)" \
	CFLAGS="-O1 -pipe" \
	CPPFLAGS="-U_FORTIFY_SOURCE" \
	LDFLAGS="" \
	"$@" || die "failed to configure glibc"
}

toolchain-glibc_do_src_configure() {
	if just_headers ; then
		toolchain-glibc_headers_configure
	else
		want_linuxthreads && glibc_do_configure linuxthreads
		want_nptl && glibc_do_configure nptl
	fi
}

toolchain-glibc_src_configure() {
	foreach_abi toolchain-glibc_do_src_configure
}

toolchain-glibc_do_src_compile() {
	local t
	for t in linuxthreads nptl ; do
		if want_${t} ; then
			[[ ${EAPI:-0} == [01] ]] && glibc_do_configure ${t}
			emake -C "$(builddir ${t})" || die "make ${t} for ${ABI} failed"
		fi
	done
}

toolchain-glibc_src_compile() {
	if just_headers ; then
		[[ ${EAPI:-0} == [01] ]] && toolchain-glibc_headers_configure
		return
	fi

	foreach_abi toolchain-glibc_do_src_compile
}

glibc_src_test() {
	cd "$(builddir $1)"
	nonfatal emake -j1 check && return 0
	einfo "make check failed - re-running with --keep-going to get the rest of the results"
	nonfatal emake -j1 -k check
	ewarn "make check failed for ${ABI}-${CTARGET}-$1"
	return 1
}

toolchain-glibc_do_src_test() {
	local ret=0 t
	for t in linuxthreads nptl ; do
		if want_${t} ; then
			glibc_src_test ${t}
			: $(( ret |= $? ))
		fi
	done
	return ${ret}
}

toolchain-glibc_src_test() {
	# Give tests more time to complete.
	export TIMEOUTFACTOR=5

	foreach_abi toolchain-glibc_do_src_test || die "tests failed"
}

toolchain-glibc_do_src_install() {
	local builddir=$(builddir $(want_linuxthreads && echo linuxthreads || echo nptl))
	cd "${builddir}"

	emake install_root="${D}$(alt_prefix)" install || die

	if want_linuxthreads && want_nptl ; then
		einfo "Installing NPTL to $(alt_libdir)/tls/..."
		cd "$(builddir nptl)"
		dodir $(alt_libdir)/tls $(alt_usrlibdir)/nptl

		local l src_lib
		for l in libc libm librt libpthread libthread_db ; do
			# take care of shared lib first ...
			l=${l}.so
			if [[ -e ${l} ]] ; then
				src_lib=${l}
			else
				src_lib=$(eval echo */${l})
			fi
			cp -a ${src_lib} "${ED}"$(alt_libdir)/tls/${l} || die "copying nptl ${l}"
			fperms a+rx $(alt_libdir)/tls/${l}
			dosym ${l} $(alt_libdir)/tls/$(scanelf -qSF'%S#F' ${src_lib})

			# then grab the linker script or the symlink ...
			if [[ -L ${ED}$(alt_usrlibdir)/${l} ]] ; then
				dosym $(alt_libdir)/tls/${l} $(alt_usrlibdir)/nptl/${l}
			else
				sed \
					-e "s:/${l}:/tls/${l}:g" \
					-e "s:/${l/%.so/_nonshared.a}:/nptl/${l/%.so/_nonshared.a}:g" \
					"${ED}"$(alt_usrlibdir)/${l} > "${ED}"$(alt_usrlibdir)/nptl/${l}
			fi

			# then grab the static lib ...
			src_lib=${src_lib/%.so/.a}
			[[ ! -e ${src_lib} ]] && src_lib=${src_lib/%.a/_pic.a}
			cp -a ${src_lib} "${ED}"$(alt_usrlibdir)/nptl/ || die "copying nptl ${src_lib}"
			src_lib=${src_lib/%.a/_nonshared.a}
			if [[ -e ${src_lib} ]] ; then
				cp -a ${src_lib} "${ED}"$(alt_usrlibdir)/nptl/ || die "copying nptl ${src_lib}"
			fi
		done

		# use the nptl linker instead of the linuxthreads one as the linuxthreads
		# one may lack TLS support and that can be really bad for business
		cp -a elf/ld.so "${ED}"$(alt_libdir)/$(scanelf -qSF'%S#F' elf/ld.so) || die "copying nptl interp"
	fi

	# Normally real_pv is ${PV}. Live ebuilds are exception, there we need
	# to infer upstream version:
	# '#define VERSION "2.26.90"' -> '2.26.90'
	local upstream_pv=$(sed -n -r 's/#define VERSION "(.*)"/\1/p' "${S}"/version.h)
	# Newer versions get fancy with libm linkage to include vectorized support.
	# While we don't really need a ldscript here, portage QA checks get upset.
	if [[ -e ${ED}$(alt_usrlibdir)/libm-${upstream_pv}.a ]] ; then
		dosym ../../$(get_libdir)/libm-${upstream_pv}.so $(alt_usrlibdir)/libm-${upstream_pv}.so
	fi

	# We'll take care of the cache ourselves
	rm -f "${ED}"/etc/ld.so.cache

	# Everything past this point just needs to be done once ...
	is_final_abi || return 0

	# Make sure the non-native interp can be found on multilib systems even
	# if the main library set isn't installed into the right place.  Maybe
	# we should query the active gcc for info instead of hardcoding it ?
	local i ldso_abi ldso_name
	local ldso_abi_list=(
		# x86
		amd64   /lib64/ld-linux-x86-64.so.2
		x32     /libx32/ld-linux-x32.so.2
		x86     /lib/ld-linux.so.2
		# mips
		o32     /lib/ld.so.1
		n32     /lib32/ld.so.1
		n64     /lib64/ld.so.1
		# powerpc
		ppc     /lib/ld.so.1
		ppc64   /lib64/ld64.so.1
		# s390
		s390    /lib/ld.so.1
		s390x   /lib/ld64.so.1
		# sparc
		sparc32 /lib/ld-linux.so.2
		sparc64 /lib64/ld-linux.so.2
	)
	case $(tc-endian) in
	little)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64.so.1
		)
		;;
	big)
		ldso_abi_list+=(
			# arm
			arm64   /lib/ld-linux-aarch64_be.so.1
		)
		;;
	esac
	if [[ ${SYMLINK_LIB} == "yes" ]] && [[ ! -e ${ED}/$(alt_prefix)/lib ]] ; then
		dosym $(get_abi_LIBDIR ${DEFAULT_ABI}) $(alt_prefix)/lib
	fi
	for (( i = 0; i < ${#ldso_abi_list[@]}; i += 2 )) ; do
		ldso_abi=${ldso_abi_list[i]}
		has ${ldso_abi} $(get_install_abis) || continue

		ldso_name="$(alt_prefix)${ldso_abi_list[i+1]}"
		if [[ ! -L ${ED}/${ldso_name} && ! -e ${ED}/${ldso_name} ]] ; then
			dosym ../$(get_abi_LIBDIR ${ldso_abi})/${ldso_name##*/} ${ldso_name}
		fi
	done

	# With devpts under Linux mounted properly, we do not need the pt_chown
	# binary to be setuid.  This is because the default owners/perms will be
	# exactly what we want.
	if in_iuse suid && ! use suid ; then
		find "${ED}" -name pt_chown -exec chmod -s {} +
	fi

	#################################################################
	# EVERYTHING AFTER THIS POINT IS FOR NATIVE GLIBC INSTALLS ONLY #
	# Make sure we install some symlink hacks so that when we build
	# a 2nd stage cross-compiler, gcc finds the target system
	# headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		# We need to make sure that /lib and /usr/lib always exists.
		# gcc likes to use relative paths to get to its multilibs like
		# /usr/lib/../lib64/.  So while we don't install any files into
		# /usr/lib/, we do need it to exist.
		cd "${ED}"$(alt_libdir)/..
		[[ -e lib ]] || mkdir lib
		cd "${ED}"$(alt_usrlibdir)/..
		[[ -e lib ]] || mkdir lib

		dosym usr/include $(alt_prefix)/sys-include
		return 0
	fi

	# Files for Debian-style locale updating
	dodir /usr/share/i18n
	sed \
		-e "/^#/d" \
		-e "/SUPPORTED-LOCALES=/d" \
		-e "s: \\\\::g" -e "s:/: :g" \
		"${S}"/localedata/SUPPORTED > "${ED}"/usr/share/i18n/SUPPORTED \
		|| die "generating /usr/share/i18n/SUPPORTED failed"
	cd "${WORKDIR}"/extra/locale
	dosbin locale-gen || die
	doman *.[0-8]
	insinto /etc
	doins locale.gen || die

	# Make sure all the ABI's can find the locales and so we only
	# have to generate one set
	local a
	keepdir /usr/$(get_libdir)/locale
	for a in $(get_install_abis) ; do
		if [[ ! -e ${ED}/usr/$(get_abi_LIBDIR ${a})/locale ]] ; then
			dosym /usr/$(get_libdir)/locale /usr/$(get_abi_LIBDIR ${a})/locale
		fi
	done

	cd "${S}"

	# Install misc network config files
	insinto /etc
	doins nscd/nscd.conf posix/gai.conf nss/nsswitch.conf || die
	doins "${WORKDIR}"/extra/etc/*.conf || die

	if ! in_iuse nscd || use nscd ; then
		doinitd "$(prefixify_ro "${WORKDIR}"/extra/etc/nscd)" || die

		local nscd_args=(
			-e "s:@PIDFILE@:$(strings "${ED}"/usr/sbin/nscd | grep nscd.pid):"
		)
		version_is_at_least 2.16 || nscd_args+=( -e 's: --foreground : :' )
		sed -i "${nscd_args[@]}" "${ED}"/etc/init.d/nscd

		# Newer versions of glibc include the nscd.service themselves.
		# TODO: Drop the $FILESDIR copy once 2.19 goes stable.
		if version_is_at_least 2.19 ; then
			systemd_dounit nscd/nscd.service || die
			systemd_newtmpfilesd nscd/nscd.tmpfiles nscd.conf || die
		else
			systemd_dounit "${FILESDIR}"/nscd.service || die
			systemd_newtmpfilesd "${FILESDIR}"/nscd.tmpfilesd nscd.conf || die
		fi
	else
		# Do this since extra/etc/*.conf above might have nscd.conf.
		rm -f "${ED}"/etc/nscd.conf
	fi

	echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00glibc
	doenvd "${T}"/00glibc || die

	for d in BUGS ChangeLog* CONFORMANCE FAQ NEWS NOTES PROJECTS README* ; do
		[[ -s ${d} ]] && dodoc ${d}
	done

	# Prevent overwriting of the /etc/localtime symlink.  We'll handle the
	# creation of the "factory" symlink in pkg_postinst().
	rm -f "${ED}"/etc/localtime
}

toolchain-glibc_headers_install() {
	local builddir=$(builddir "headers")
	cd "${builddir}"
	emake install_root="${D}$(alt_prefix)" install-headers || die
	if ! version_is_at_least 2.16 ; then
		insinto $(alt_headers)/bits
		doins bits/stdio_lim.h || die
	fi
	insinto $(alt_headers)/gnu
	doins "${S}"/include/gnu/stubs.h || die "doins include gnu"
	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	dosym usr/include $(alt_prefix)/sys-include
}

src_strip() {
	# gdb is lame and requires some debugging information to remain in
	# libpthread, so we need to strip it by hand.  libthread_db makes no
	# sense stripped as it is only used when debugging.
	local pthread=$(has splitdebug ${FEATURES} && echo "libthread_db" || echo "lib{pthread,thread_db}")
	env \
		-uRESTRICT \
		CHOST=${CTARGET} \
		STRIP_MASK="/*/{,tls/}${pthread}*" \
		prepallstrip
	# if user has stripping enabled and does not have split debug turned on,
	# then leave the debugging sections in libpthread.
	if ! has nostrip ${FEATURES} && ! has splitdebug ${FEATURES} ; then
		${STRIP:-${CTARGET}-strip} --strip-debug "${ED}"/*/libpthread-*.so
	fi
}

toolchain-glibc_src_install() {
	if just_headers ; then
		export ABI=default
		toolchain-glibc_headers_install
		return
	fi

	foreach_abi toolchain-glibc_do_src_install
	src_strip
}

# Simple test to make sure our new glibc isn't completely broken.
# Make sure we don't test with statically built binaries since
# they will fail.  Also, skip if this glibc is a cross compiler.
#
# If coreutils is built with USE=multicall, some of these files
# will just be wrapper scripts, not actual ELFs we can test.
glibc_sanity_check() {
	cd / #228809

	# We enter ${ED} so to avoid trouble if the path contains
	# special characters; for instance if the path contains the
	# colon character (:), then the linker will try to split it
	# and look for the libraries in an unexpected place. This can
	# lead to unsafe code execution if the generated prefix is
	# within a world-writable directory.
	# (e.g. /var/tmp/portage:${HOSTNAME})
	pushd "${ED}"/$(get_libdir) >/dev/null

	local x striptest
	for x in cal date env free ls true uname uptime ; do
		x=$(type -p ${x})
		[[ -z ${x} || ${x} != ${EPREFIX}/* ]] && continue
		striptest=$(LC_ALL="C" file -L ${x} 2>/dev/null) || continue
		case ${striptest} in
		*"statically linked"*) continue;;
		*"ASCII text"*) continue;;
		esac
		# We need to clear the locale settings as the upgrade might want
		# incompatible locale data.  This test is not for verifying that.
		LC_ALL=C \
		./ld-*.so --library-path . ${x} > /dev/null \
			|| die "simple run test (${x}) failed"
	done

	popd >/dev/null
}

toolchain-glibc_pkg_preinst() {
	# nothing to do if just installing headers
	just_headers && return

	# prepare /etc/ld.so.conf.d/ for files
	mkdir -p "${EROOT}"/etc/ld.so.conf.d

	# Default /etc/hosts.conf:multi to on for systems with small dbs.
	if [[ $(wc -l < "${EROOT}"/etc/hosts) -lt 1000 ]] ; then
		sed -i '/^multi off/s:off:on:' "${ED}"/etc/host.conf
		elog "Defaulting /etc/host.conf:multi to on"
	fi

	[[ ${ROOT} != "/" ]] && return 0
	[[ -d ${ED}/$(get_libdir) ]] || return 0
	[[ -z ${BOOTSTRAP_RAP} ]] && glibc_sanity_check

	# For newer EAPIs, this was run in pkg_pretend.
	if [[ ${EAPI:-0} == [0123] ]] ; then
		check_devpts
	fi
}

toolchain-glibc_pkg_postinst() {
	# nothing to do if just installing headers
	just_headers && return

	if ! tc-is-cross-compiler && [[ -x ${EROOT}/usr/sbin/iconvconfig ]] ; then
		# Generate fastloading iconv module configuration file.
		"${EROOT}"/usr/sbin/iconvconfig --prefix="${ROOT}"
	fi

	if ! is_crosscompile && [[ ${ROOT} == "/" ]] ; then
		# Reload init ... if in a chroot or a diff init package, ignore
		# errors from this step #253697
		/sbin/telinit U 2>/dev/null

		# if the host locales.gen contains no entries, we'll install everything
		local locale_list="${EROOT}etc/locale.gen"
		if [[ -z $(locale-gen --list --config "${locale_list}") ]] ; then
			ewarn "Generating all locales; edit /etc/locale.gen to save time/space"
			locale_list="${EROOT}usr/share/i18n/SUPPORTED"
		fi
		locale-gen -j $(makeopts_jobs) --config "${locale_list}"
	fi
}

_TOOLCHAIN_GLIBC_ECLASS=1
fi
