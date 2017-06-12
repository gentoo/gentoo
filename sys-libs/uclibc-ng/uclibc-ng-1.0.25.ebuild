# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic multilib savedconfig toolchain-funcs versionator

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://uclibc-ng.org/git/uclibc-ng"
	inherit git-r3
	MY_P=uclibc-ng-${PV}
else
	MY_P=uClibc-ng-${PV}
fi

DESCRIPTION="C library for developing embedded Linux systems"
HOMEPAGE="http://www.uclibc-ng.org/"
if [[ ${PV} != "9999" ]] ; then
	PATCH_VER=""
	SRC_URI="http://downloads.uclibc-ng.org/releases/${PV}/${MY_P}.tar.bz2"
	#KEYWORDS="-* ~amd64 ~arm ~mips ~ppc ~x86"
	KEYWORDS="-* ~amd64 ~arm ~ppc ~x86"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug hardened iconv ipv6 rpc symlink-compat crosscompile_opts_headers-only"
RESTRICT="strip"

# 1) We can't upgrade from uclibc to uclibc-ng via a soft blocker since portage
#    will delete the ld.so sym link prematurely and break the system. So we
#    will hard block and give manual migration instructions.
# 2) Currently uclibc and uclibc-ng's iconv are in bad shape.  We've been using
#    the breakout library.  The disadvantage here is that we have to sprinkle
#    LDFAGS=-liconv on build systems that need to link against libiconv.
RDEPEND="
	!!sys-libs/uclibc
	iconv? ( dev-libs/libiconv )"

S=${WORKDIR}/${MY_P}

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CHOST} == ${CTARGET} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

alt_build_kprefix() {
	if [[ ${CBUILD} == ${CHOST} && ${CHOST} == ${CTARGET} ]] ; then
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

make_oldconfig() {
	yes "" 2>/dev/null | emake -s oldconfig >/dev/null
}

make_config() {
	restore_config .config
	if [ -f .config ]; then
		make_oldconfig
		return 0
	else
		ewarn "Could not locate user configfile, so we will save a default one"
	fi

	emake ARCH=$1 defconfig >/dev/null

	local defs_{y,n}

	# These are forced off
	defs_n=(
		DOASSERTS
		DODEBUG_PT
		HAS_NO_THREADS
		PROPOLICE_BLOCK_ABRT
		SSP_QUICK_CANARY
		SUPPORT_LD_DEBUG_EARLY
		UCLIBC_HAS_CTYPE_UNSAFE
		UCLIBC_HAS_LOCALE
		UCLIBC_HAS_SSP_COMPAT
	)

	# These are forced on
	defs_y=(
		COMPAT_ATEXIT
		DO_C99_MATH
		DO_XSI_MATH
		FORCE_SHAREABLE_TEXT_SEGMENTS
		LDSO_GNU_HASH_SUPPORT
		LDSO_PRELINK_SUPPORT
		LDSO_PRELOAD_FILE_SUPPORT
		LDSO_RUNPATH_OF_EXECUTABLE
		LDSO_STANDALONE_SUPPORT
		MALLOC_GLIBC_COMPAT
		PROPOLICE_BLOCK_SEGV
		PTHREADS_DEBUG_SUPPORT
		UCLIBC_HAS_ARC4RANDOM
		UCLIBC_HAS_BACKTRACE
		UCLIBC_HAS_BSD_RES_CLOSE
		UCLIBC_HAS_CONTEXT_FUNCS
		UCLIBC_HAS_CTYPE_CHECKED
		UCLIBC_HAS_EXTRA_COMPAT_RES_STATE
		UCLIBC_HAS_FENV
		UCLIBC_HAS_FOPEN_CLOSEEXEC_MODE
		UCLIBC_HAS_FOPEN_EXCLUSIVE_MODE
		UCLIBC_HAS_FOPEN_LARGEFILE_MODE
		UCLIBC_HAS_FTS
		UCLIBC_HAS_FTW
		UCLIBC_HAS_GETPT
		UCLIBC_HAS_GLIBC_CUSTOM_PRINTF
		UCLIBC_HAS_GLIBC_CUSTOM_STREAMS
		UCLIBC_HAS_GNU_GLOB
		UCLIBC_HAS_HEXADECIMAL_FLOATS
		UCLIBC_HAS_LIBNSL_STUB
		UCLIBC_HAS_LIBRESOLV_STUB
		UCLIBC_HAS_LIBUTIL
		UCLIBC_HAS_NFTW
		UCLIBC_HAS_OBSOLETE_BSD_SIGNAL
		UCLIBC_HAS_OBSTACK
		UCLIBC_HAS_PRINTF_M_SPEC
		UCLIBC_HAS_PROGRAM_INVOCATION_NAME
		UCLIBC_HAS_RESOLVER_SUPPORT
		UCLIBC_HAS_SHA256_CRYPT_IMPL
		UCLIBC_HAS_SHA512_CRYPT_IMPL
		UCLIBC_HAS_SSP
		UCLIBC_HAS_STUBS
		UCLIBC_HAS_SYS_ERRLIST
		UCLIBC_HAS_SYS_SIGLIST
		UCLIBC_HAS_THREADS_NATIVE
		UCLIBC_HAS_TZ_FILE_READ_MANY
		UCLIBC_HAS_UTMP
		UCLIBC_HAS_UTMPX
		UCLIBC_HAS_WCHAR
		UCLIBC_HAS_WORDEXP
		UCLIBC_NTP_LEGACY
		UCLIBC_SUPPORT_AI_ADDRCONFIG
		UCLIBC_SUSV2_LEGACY
		UCLIBC_SUSV3_LEGACY
		UCLIBC_SUSV3_LEGACY_MACROS
		UCLIBC_SUSV4_LEGACY
		UCLIBC_USE_NETLINK
	)

	sed -i -e '/ARCH_.*_ENDIAN/d' .config
	kconfig_q_opt y "ARCH_WANTS_$(uclibc_endian)_ENDIAN"

	kconfig_q_opt debug DODEBUG
	kconfig_q_opt debug SUPPORT_LD_DEBUG
	kconfig_q_opt debug UCLIBC_HAS_PROFILING

	kconfig_q_opt ipv6 UCLIBC_HAS_IPV6

	kconfig_q_opt rpc UCLIBC_HAS_RPC
	kconfig_q_opt rpc UCLIBC_HAS_FULL_RPC
	kconfig_q_opt rpc UCLIBC_HAS_REENTRANT_RPC

	kconfig_q_opt hardened UCLIBC_BUILD_NOEXECSTACK
	kconfig_q_opt hardened UCLIBC_BUILD_NOW
	kconfig_q_opt hardened UCLIBC_BUILD_PIE
	kconfig_q_opt hardened UCLIBC_BUILD_RELRO
	kconfig_q_opt hardened UCLIBC_BUILD_SSP

	local count def
	for count in 1 2 ; do
		# Run twice as some config opts depend on others being enabled first.
		for def in ${defs_y[@]} ; do
			sed -i -e "s|.*\<${def}\>.*set|${def}=y|g" .config
		done
		for def in ${defs_n[@]} ; do
			sed -i -e "s|${def}=y|# ${def} is not set|g" .config
		done
		make_oldconfig
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
		-e "/^CROSS_COMPILER_PREFIX/s|=.*|=\"${CTARGET}-\"|" \
		-e "/^KERNEL_HEADERS/s|=.*|=\"$(alt_build_kprefix)\"|" \
		-e "/^SHARED_LIB_LOADER_PREFIX/s|=.*|=\"/$(get_libdir)\"|" \
		-e "/^DEVEL_PREFIX/s|=.*|=\"/usr\"|" \
		-e "/^RUNTIME_PREFIX/s|=.*|=\"/\"|" \
		-e "/^UCLIBC_EXTRA_CFLAGS/s|=.*|=\"${UCLIBC_EXTRA_CFLAGS}\"|" \
		.config || die

	make_oldconfig
}

pkg_setup() {
	# Make sure our CHOST is a uclibc toolchain for native compiling
	if [[ ${CHOST} == ${CTARGET} ]]; then
		case ${CHOST} in
			*-uclinux*|*-uclibc*) ;;
			*) die "Use sys-devel/crossdev to build a uclibc toolchain" ;;
		esac
	fi

	# uClibc-ng doesn't carry old Linux threads, and since we force
	# threading our only choice is NPTL which requires i486 and later.
	[[ ${CTARGET} == i386* ]] && die "i386 can't support Native Posix Threads (NPTL)."
}

src_prepare() {
	local version subversion extraversion

	# uclibc-ng tries to create a two sym link with ld.so,
	# ld-uClibc.so.{0,MAJOR_VERSION} -> ld-uClibc-<version>.so
	# where MAJOR_VERSION != 0 indicates the ABI verison.
	# We want to get rid of this and just have ABI = 0.
	eapply "${FILESDIR}"/uclibc-compat-r1.patch

	# We need to change the major.minor.sublevel of uclibc-ng.
	# Upstream sets MAJOR_VERSION = 1 which breaks runtime linking.
	# If we really want the ABI bump, we'll have to hack the gcc
	# spec file and change the '*link:' rule.
	version=( $(get_version_components) )
	if [[ -z ${version[1]} ]]; then
		subversion=0
		extraversion=0
	else
		subversion=${version[1]}
		if [[ -z ${version[2]} ]]; then
			extraversion=0
		else
			extraversion=.${version[2]}
		fi
	fi

	sed -i \
		-e "/^MAJOR_VERSION/s|:=.*|:= 0|" \
		-e "/^MINOR_VERSION/s|:=.*|:= ${version[0]}|" \
		-e "/^SUBLEVEL/s|:=.*|:= ${subversion}|" \
		-e "/^EXTRAVERSION/s|:=.*|:= ${extraversion}|" \
		Rules.mak || die

	eapply_user
}

src_configure() {
	# Map our toolchain arch name to the name expected by uClibc-ng.
	local target=$(tc-arch)
	case ${target} in
		amd64) target="x86_64";;
		arm)   target="arm";;
		mips)  target="mips";;
		ppc)   target="powerpc";;
		x86)   target="i386";;
	esac

	# Do arch specific configuration by changing the defaults in
	# extra/Configs/Config.<arch>.  If these are not overridden
	# by an save .config, they will be selected by default.

	# For i386, i486, i586 and i686
	local cpu
	if [[ ${target} == "i386" ]]; then
		[[ ${CTARGET} == i[456]86* ]] && cpu="${CTARGET:1:1}86"
		sed -i -e "s|default CONFIG_686|default CONFIG_${cpu:-486}|" \
			extra/Configs/Config.i386 || die
	fi

	# For arm
	if [[ ${target} == "arm" ]]; then
		sed -i -e '/Build for EABI/a \\tdefault y' extra/Configs/Config.arm
	fi

	# We set HOSTCC to the proper tuple rather than just 'gcc'
	sed -i -e "s|^HOSTCC.*=.*|HOSTCC=$(tc-getBUILD_CC)|" Rules.mak

	make_config ${target}

	einfo
	einfo "Runtime Prefix: /"
	einfo "Devel Prefix:   /usr"
	einfo "Kernel Prefix:  $(alt_build_kprefix)"
	einfo "CBUILD:         ${CBUILD}"
	einfo "CHOST:          ${CHOST}"
	einfo "CTARGET:        ${CTARGET}"
	einfo "ABI:            ${ABI}"
	einfo "ENDIAN:         $(uclibc_endian)"
	einfo
}

src_compile() {
	emake headers
	just_headers && return 0

	emake
	if is_crosscompile ; then
		emake -C utils hostutils
	else
		emake utils
	fi
}

src_test() {
	is_crosscompile && return 0

	# assert test fails on pax/grsec enabled kernels
	# normal vfork test fails in sandbox (both glibc/uclibc)
	emake UCLIBC_ONLY=1 check
}

src_install() {
	local sysroot=${D}
	is_crosscompile && sysroot+="/usr/${CTARGET}"

	local target="install"
	just_headers && target="install_headers"
	emake DESTDIR="${sysroot}" ${target}

	save_config .config

	# remove files coming from kernel-headers
	rm -rf "${sysroot}"/usr/include/{linux,asm*}

	# Make sure we install the sys-include symlink so that when
	# we build a 2nd stage cross-compiler, gcc finds the target
	# system headers correctly.  See gcc/doc/gccinstall.info
	if is_crosscompile ; then
		dosym usr/include /usr/${CTARGET}/sys-include
		if ! just_headers && [[ -n $(get_opt HAVE_SHARED) ]] ; then
			newbin utils/ldconfig.host ${CTARGET}-ldconfig
			newbin utils/ldd.host ${CTARGET}-ldd
		fi
		return 0
	fi

	if use symlink-compat; then
		dosym libc.so.0 "${DESTDIR}"/lib/libcrypt.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libdl.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libm.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libpthread.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/librt.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libresolv.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libubacktrace.so.0
		dosym libc.so.0 "${DESTDIR}"/lib/libutil.so.0
	fi

	emake DESTDIR="${D}" install_utils
	dobin extra/scripts/getent
	dodoc README docs/*.txt
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
