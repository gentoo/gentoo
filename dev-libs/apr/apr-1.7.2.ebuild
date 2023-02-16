# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="https://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1/${PV%.*}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc old-kernel selinux static-libs +urandom"

# See bug #815265 for libcrypt dependency
DEPEND="
	virtual/libcrypt:=
	elibc_glibc? ( >=sys-apps/util-linux-2.16 )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-base-policy )
"
BDEPEND="
	>=sys-devel/libtool-2.4.2
	doc? ( app-doc/doxygen )
"

DOCS=( CHANGES NOTICE README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-mint.patch
	"${FILESDIR}"/${PN}-1.6.3-skip-known-failing-tests.patch
	"${FILESDIR}"/${PN}-1.7.2-libtool.patch
	"${FILESDIR}"/${PN}-1.7.2-sysroot.patch # bug #385775
	"${FILESDIR}"/${PN}-1.7.2-fix-pkgconfig-libs.patch
	"${FILESDIR}"/${PN}-1.7.2-respect-flags.patch
	"${FILESDIR}"/config.layout.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	AT_M4DIR="build" eautoreconf
}

src_configure() {
	tc-export AS CC CPP

	local myconf=(
		--enable-layout=gentoo
		--enable-nonportable-atomics
		--enable-posix-shm
		--enable-threads
		$(use_enable static-libs static)
		--with-installbuilddir="${EPREFIX}"/usr/share/${PN}/build
	)

	tc-is-static-only && myconf+=( --disable-dso )

	if use old-kernel; then
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
			ac_cv_mmap__dev_zero="yes" \
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
		: # no /dev/*random on hpux11.11 and before, apr detects this.
	else
		myconf+=( --with-devrandom=/dev/random )
	fi

	# shl_load does not search runpath, but hpux11 supports dlopen
	if [[ ${CHOST} == *-hpux11* ]]; then
		myconf+=( --enable-dso=dlfcn )
	elif [[ ${CHOST} == *-solaris2.10 ]]; then
		local atomic_contents=$(<$([[ ${CHOST} != ${CBUILD} ]] && echo "${EPREFIX}/usr/${CHOST}")/usr/include/atomic.h)

		case "${atomic_contents}" in
			*atomic_cas_ptr*)
				;;
			*)
				local patch_id=$([[ ${CHOST} == sparc* ]] && echo 118884 || echo 118885)

				elog "You do not have Solaris Patch ID ${patch_id} (Problem 4954703) installed on your host ($(hostname)),"
				elog "using generic atomic operations instead."

				myconf+=( --disable-nonportable-atomics )
				;;
		esac
	else
		if use ppc || use sparc || use mips; then
			# Avoid libapr containing undefined references (underlinked)
			# undefined reference to `__sync_val_compare_and_swap_8'
			# (May be possible to fix via libatomic linkage in future?)
			# bug #740464
			myconf+=( --disable-nonportable-atomics )
		fi
	fi

	econf "${myconf[@]}"
}

src_compile() {
	if tc-is-cross-compiler; then
		# This header is the same across targets, so use the build compiler.
		emake tools/gen_test_char

		tc-export_build_env BUILD_CC
		${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_CPPFLAGS} ${BUILD_LDFLAGS} \
			tools/gen_test_char.c -o tools/gen_test_char || die
	fi

	emake all $(usev doc dox)
}

src_test() {
	# Building tests in parallel is broken
	emake -j1 check
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	if use doc; then
		docinto html
		dodoc -r docs/dox/html/*
	fi

	# This file is only used on AIX systems, which Gentoo is not,
	# and causes collisions between the SLOTs, so remove it.
	# Even in Prefix, we don't need this on AIX.
	rm "${ED}/usr/$(get_libdir)/apr.exp" || die
}
