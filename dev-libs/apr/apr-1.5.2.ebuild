# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr/apr-1.5.2.ebuild,v 1.9 2015/06/28 18:00:29 zlogene Exp $

EAPI=5

inherit autotools eutils libtool multilib toolchain-funcs

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc elibc_FreeBSD older-kernels-compatibility selinux static-libs +urandom"

CDEPEND="elibc_glibc? ( >=sys-apps/util-linux-2.16 )
	elibc_mintlib? ( >=sys-apps/util-linux-2.18 )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-apache )"
DEPEND="${CDEPEND}
	>=sys-devel/libtool-2.4.2
	doc? ( app-doc/doxygen )"

DOCS=(CHANGES NOTICE README)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5.0-mint.patch
	epatch "${FILESDIR}"/${PN}-1.5.0-libtool.patch
	epatch "${FILESDIR}"/${PN}-1.5.0-cross-types.patch
	epatch "${FILESDIR}"/${PN}-1.5.0-sysroot.patch #385775

	epatch_user #449048

	AT_M4DIR="build" eautoreconf
	elibtoolize

	epatch "${FILESDIR}/config.layout.patch"
}

src_configure() {
	local myconf=()

	[[ ${CHOST} == *-mint* ]] && export ac_cv_func_poll=no

	if use older-kernels-compatibility; then
		local apr_cv_accept4 apr_cv_dup3 apr_cv_epoll_create1 apr_cv_sock_cloexec
		export apr_cv_accept4="no"
		export apr_cv_dup3="no"
		export apr_cv_epoll_create1="no"
		export apr_cv_sock_cloexec="no"
	fi
	if tc-is-cross-compiler; then
		# The apache project relies heavily on AC_TRY_RUN and doesn't
		# have any sane cross-compiling fallback logic.
		export \
			ac_cv_file__dev_zero="yes" \
			ac_cv_func_sem_open="yes" \
			ac_cv_negative_eai="yes" \
			ac_cv_o_nonblock_inherited="no" \
			ac_cv_struct_rlimit="yes" \
			ap_cv_atomic_builtins="yes" \
			apr_cv_accept4="yes" \
			apr_cv_dup3="yes" \
			apr_cv_epoll="yes" \
			apr_cv_epoll_create1="yes" \
			apr_cv_gai_addrconfig="yes" \
			apr_cv_mutex_recursive="yes" \
			apr_cv_mutex_robust_shared="yes" \
			apr_cv_process_shared_works="yes" \
			apr_cv_pthreads_lib="-pthread" \
			apr_cv_sock_cloexec="yes" \
			apr_cv_tcp_nodelay_with_cork="yes"
	fi

	if use urandom; then
		myconf+=( --with-devrandom=/dev/urandom )
	elif (( ${CHOST#*-hpux11.} <= 11 )); then
		: # no /dev/*random on hpux11.11 and before, $PN detects this.
	else
		myconf+=( --with-devrandom=/dev/random )
	fi

	tc-is-static-only && myconf+=( --disable-dso )

	# shl_load does not search runpath, but hpux11 supports dlopen
	[[ ${CHOST} == *-hpux11* ]] && myconf+=( --enable-dso=dlfcn )

	if [[ ${CHOST} == *-solaris2.10 ]]; then
		case $(<$([[ ${CHOST} != ${CBUILD} ]] && echo "${EPREFIX}/usr/${CHOST}")/usr/include/atomic.h) in
		*atomic_cas_ptr*) ;;
		*)
			elog "You do not have Solaris Patch ID "$(
				[[ ${CHOST} == sparc* ]] && echo 118884 || echo 118885
			)" (Problem 4954703) installed on your host ($(hostname)),"
			elog "using generic atomic operations instead."
			myconf+=( --disable-nonportable-atomics )
			;;
		esac
	fi

	econf \
		--enable-layout=gentoo \
		--enable-nonportable-atomics \
		--enable-posix-shm \
		--enable-threads \
		$(use_enable static-libs static) \
		"${myconf[@]}"
}

src_compile() {
	if tc-is-cross-compiler; then
		# This header is the same across targets, so use the build compiler.
		emake tools/gen_test_char
		tc-export_build_env BUILD_CC
		${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_CPPFLAGS} ${BUILD_LDFLAGS} \
			tools/gen_test_char.c -o tools/gen_test_char || die
	fi

	emake

	if use doc; then
		emake dox
	fi
}

src_install() {
	default

	# Prallel install breaks since apr-1.5.1
	#make -j1 DESTDIR="${D}" install || die

	prune_libtool_files --all

	if use doc; then
		dohtml -r docs/dox/html/*
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	# Even in Prefix, we don't need this on AIX.
	rm -f "${ED}usr/$(get_libdir)/apr.exp"
}
