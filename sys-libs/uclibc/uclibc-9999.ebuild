# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic multilib toolchain-funcs savedconfig
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.busybox.net/uClibc"
	inherit git-2
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

MY_P=uClibc-${PV}
DESCRIPTION="C library for developing embedded Linux systems"
HOMEPAGE="https://www.uclibc.org/"
if [[ ${PV} != "9999" ]] ; then
	PATCH_VER=""
	SRC_URI="https://uclibc.org/downloads/${MY_P}.tar.bz2
		${PATCH_VER:+mirror://gentoo/${MY_P}-patches-${PATCH_VER}.tar.bz2}"
	KEYWORDS="-* ~amd64 ~arm ~m68k ~mips ~ppc ~sh ~sparc ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug hardened iconv ipv6 nptl rpc ssp uclibc-compat wordexp crosscompile_opts_headers-only"
RESTRICT="strip"

# We cannot migrate between uclibc and uclibc-ng because as soon as portage
# updates the ld.so sym link, the system breaks.  Ideally this should be a
# hard blocker, but EAPI=0 doesn't allow hard blockers.
RDEPEND="!sys-libs/uclibc-ng"

S=${WORKDIR}/${MY_P}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
alt_build_kprefix() {
	if [[ ${CBUILD} == ${CHOST} && ${CTARGET} == ${CHOST} ]] ; then
		echo /usr/include
	else
		echo /usr/${CTARGET}/usr/include
	fi
}

just_headers() {
	use crosscompile_opts_headers-only && is_crosscompile
}

uclibc_endian() {
	# XXX: this wont work for a toolchain which is bi-endian, but we
	#      dont have any such thing at the moment, so not a big deal
	touch "${T}"/endian.s
	$(tc-getAS ${CTARGET}) "${T}"/endian.s -o "${T}"/endian.o
	case $(file "${T}"/endian.o) in
		*" MSB "*) echo "BIG";;
		*" LSB "*) echo "LITTLE";;
		*)         echo "NFC";;
	esac
	rm -f "${T}"/endian.{s,o}
}

pkg_setup() {
	if [ ${CTARGET} = ${CHOST} ] ; then
		case ${CHOST} in
		*-uclinux*|*-uclibc*) ;;
		*) die "Use sys-devel/crossdev to build a uclibc toolchain" ;;
		esac
	fi
}

check_cpu_opts() {
	case ${CTARGET} in
	# Need to handle $ABI here w/mips.
	mips[1234]*) export UCLIBC_CPU="MIPS_ISA_${CTARGET:4:1}";;
	sh[2345]*)   export UCLIBC_CPU="SH${CTARGET:2:1}";;
	i[3456]86*)  export UCLIBC_CPU="${CTARGET:1:1}86";;
	# XXX: Should figure out how to handle sparc.
	esac

	if use nptl ; then
		case ${CTARGET} in
		i386*)
			die "Your target has no support for NPTL"
			;;
		esac
	fi
}

kconfig_q_opt() {
	local flag=$1; shift
	case ${flag} in
	y|n) ;;
	*) flag=$(usex ${flag} y n) ;;
	esac

	local var="defs_${flag}"
	eval "${var}+=( $* )"
}

get_opt() {
	(
	unset ${1}
	. ${2:-"${S}"/.config}
	echo ${!1}
	)
}

src_oldconfig() {
	yes "" 2>/dev/null | emake -s oldconfig >/dev/null
}
src_config() {
	restore_config .config
	if [ -f .config ]; then
		src_oldconfig
		return 0
	else
		ewarn "Could not locate user configfile, so we will save a default one"
	fi

	emake ARCH=${target} defconfig >/dev/null || die

	local defs_{y,n} defs

	defs=(
		DO{DEBUG_PT,ASSERTS}
		SUPPORT_LD_DEBUG_EARLY
		UCLIBC_HAS_PROFILING
	)
	kconfig_q_opt n "${defs[@]}"
	kconfig_q_opt debug DODEBUG SUPPORT_LD_DEBUG

	sed -i -e '/ARCH_.*_ENDIAN/d' .config
	kconfig_q_opt y "ARCH_WANTS_$(uclibc_endian)_ENDIAN"

	if [[ ${CTARGET} == arm* ]] ; then
		kconfig_q_opt n CONFIG_ARM_OABI
		kconfig_q_opt y CONFIG_ARM_EABI
	fi

	defs=(
		LDSO_GNU_HASH_SUPPORT
		MALLOC_GLIBC_COMPAT
		DO_C99_MATH
		UCLIBC_HAS_{CTYPE_CHECKED,WCHAR,HEXADECIMAL_FLOATS,GLIBC_CUSTOM_PRINTF,FOPEN_EXCLUSIVE_MODE,GLIBC_CUSTOM_STREAMS,PRINTF_M_SPEC}
		UCLIBC_HAS_FENV
		UCLIBC_HAS_{N,}FTW
		UCLIBC_HAS_GNU_GLOB
		UCLIBC_HAS_LIBUTIL
		UCLIBC_HAS_PROGRAM_INVOCATION_NAME
		UCLIBC_HAS_RESOLVER_SUPPORT
		UCLIBC_HAS_TZ_FILE_READ_MANY
		UCLIBC_HAS_UTMPX
		UCLIBC_SUPPORT_AI_ADDRCONFIG
		UCLIBC_SUSV3_LEGACY
		UCLIBC_SUSV3_LEGACY_MACROS
		UCLIBC_SUSV4_LEGACY
		UCLIBC_USE_NETLINK
		PTHREADS_DEBUG_SUPPORT
	)
	kconfig_q_opt y "${defs[@]}"
	kconfig_q_opt n UCLIBC_HAS_CTYPE_UNSAFE
	kconfig_q_opt n UCLIBC_HAS_LOCALE
	kconfig_q_opt n HAS_NO_THREADS
	kconfig_q_opt ipv6 UCLIBC_HAS_IPV6
	kconfig_q_opt nptl UCLIBC_HAS_THREADS_NATIVE
	kconfig_q_opt !nptl LINUXTHREADS_OLD
	kconfig_q_opt rpc UCLIBC_HAS_{,{FULL,REENTRANT}_}RPC
	kconfig_q_opt wordexp UCLIBC_HAS_WORDEXP
	kconfig_q_opt uclibc-compat UCLIBC_HAS_LIB{NSL,RESOLV}_STUB COMPAT_ATEXIT

	# we need to do it independently of hardened to get ssp.c built into libc
	kconfig_q_opt y UCLIBC_HAS_SSP
	kconfig_q_opt n UCLIBC_HAS_SSP_COMPAT
	kconfig_q_opt y UCLIBC_HAS_ARC4RANDOM
	kconfig_q_opt n PROPOLICE_BLOCK_ABRT
	kconfig_q_opt y PROPOLICE_BLOCK_SEGV

	# arm/mips do not emit PT_GNU_STACK, but if we enable this here
	# it will be emitted as RWE, ppc has to be checked, x86 needs it
	# this option should be used independently of hardened
	if has $(tc-arch) x86 || has $(tc-arch) ppc ; then
		kconfig_q_opt y UCLIBC_BUILD_NOEXECSTACK
	else
		kconfig_q_opt n UCLIBC_BUILD_NOEXECSTACK
	fi
	kconfig_q_opt y UCLIBC_BUILD_RELRO
	kconfig_q_opt hardened UCLIBC_BUILD_PIE
	kconfig_q_opt hardened UCLIBC_BUILD_NOW
	kconfig_q_opt !ssp SSP_QUICK_CANARY
	kconfig_q_opt ssp UCLIBC_BUILD_SSP

	local def
	for def in 1 2 ; do
		# Run twice as some config opts depend on others being enabled first.
		for def in ${defs_y[@]} ; do
			sed -i -e "s:.*\<${def}\>.*set:${def}=y:g" .config
		done
		for def in ${defs_n[@]} ; do
			sed -i -e "s:${def}=y:# ${def} is not set:g" .config
		done
		src_oldconfig
	done

	einfo "Enabled options:"
	for def in ${defs_y[@]} ; do
		einfo " " $(grep "^${def}=y" .config || echo "could not find ${def}")
	done
	einfo "Disabled options:"
	for def in ${defs_n[@]} ; do
		einfo " " $(grep "^# ${def} is not set" .config || echo "could not find ${def}")
	done

	# setup build and run paths
	sed -i \
		-e "/^CROSS_COMPILER_PREFIX/s:=.*:=\"${CTARGET}-\":" \
		-e "/^KERNEL_HEADERS/s:=.*:=\"$(alt_build_kprefix)\":" \
		-e "/^SHARED_LIB_LOADER_PREFIX/s:=.*:=\"/$(get_libdir)\":" \
		-e "/^DEVEL_PREFIX/s:=.*:=\"/usr\":" \
		-e "/^RUNTIME_PREFIX/s:=.*:=\"/\":" \
		-e "/^UCLIBC_EXTRA_CFLAGS/s:=.*:=\"${UCLIBC_EXTRA_CFLAGS}\":" \
		.config || die

	src_oldconfig
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"
	if [[ -n ${PATCH_VER} ]] ; then
		EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	fi

	epatch_user

	check_cpu_opts

	echo
	einfo "Runtime Prefix: /"
	einfo "Devel Prefix:   /usr"
	einfo "Kernel Prefix:  $(alt_build_kprefix)"
	einfo "CBUILD:         ${CBUILD}"
	einfo "CHOST:          ${CHOST}"
	einfo "CTARGET:        ${CTARGET}"
	einfo "CPU:            ${UCLIBC_CPU:-default}"
	einfo "ENDIAN:         $(uclibc_endian)"
	echo

	########## CPU SELECTION ##########

	local target=$(tc-arch) config_target
	case ${target} in
	amd64) target="x86_64";;
	arm)   target="arm";     config_target="GENERIC_ARM";;
	avr)   target="avr32";;
	mips)  target="mips";    config_target="MIPS_ISA_1";;
	ppc)   target="powerpc";;
	sh)    target="sh";      config_target="SH4";;
	x86)   target="i386";    config_target="486";;
	esac
	if [[ -n ${config_target} ]] ; then
		sed -i -e "s:default CONFIG_${config_target}:default CONFIG_${UCLIBC_CPU:-${config_target}}:" \
			extra/Configs/Config.${target} || die
	fi
	sed -i -e "s:^HOSTCC.*=.*:HOSTCC=$(tc-getBUILD_CC):" Rules.mak

	src_config

	if use iconv ; then
		# Run after make clean, otherwise files removed
		find ./extra/locale/charmaps -name "*.pairs" > extra/locale/codesets.txt
		if [[ ! -f /etc/locale.gen ]] ; then
			# See ./extra/locale/LOCALES for examples
			die "Please create an appropriate /etc/locale.gen for locale support"
		fi
		echo -e "@euro e\n@cyrillic c\n#---\nUTF-8 yes\n8-BIT yes\n#---\n\n" > ./extra/locale/locales.txt
		cat /etc/locale.gen >> ./extra/locale/locales.txt
	fi
}

src_compile() {
	emake headers || die
	just_headers && return 0

	emake || die
	if is_crosscompile ; then
		emake -C utils hostutils || die
	else
		emake utils || die
	fi
}

src_test() {
	is_crosscompile && return 0

	# assert test fails on pax/grsec enabled kernels - normal
	# vfork test fails in sandbox (both glibc/uclibc)
	emake UCLIBC_ONLY=1 check || die
}

src_install() {
	local sysroot=${D}
	is_crosscompile && sysroot+="/usr/${CTARGET}"

	local target="install"
	just_headers && target="install_headers"
	emake DESTDIR="${sysroot}" ${target} || die

	save_config .config

	# remove files coming from kernel-headers
	rm -rf "${sysroot}"/usr/include/{linux,asm*}

	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		dosym usr/include /usr/${CTARGET}/sys-include
		if ! just_headers && [[ -n $(get_opt HAVE_SHARED) ]] ; then
			newbin utils/ldconfig.host ${CTARGET}-ldconfig || die
			newbin utils/ldd.host ${CTARGET}-ldd || die
		fi
		return 0
	fi

	emake DESTDIR="${D}" install_utils || die
	dobin extra/scripts/getent
	dodoc Changelog* README TODO docs/*.txt DEDICATION.mjn3
}

pkg_postinst() {
	is_crosscompile && return 0

	if [ ! -e "${ROOT}"/etc/TZ ] ; then
		ewarn "Please remember to set your timezone in /etc/TZ"
		mkdir -p "${ROOT}"/etc
		echo "UTC" > "${ROOT}"/etc/TZ
	fi
	[ "${ROOT}" != "/" ] && return 0
	# update cache before reloading init
	ldconfig
	# reload init ...
	/sbin/telinit U 2>/dev/null
}
