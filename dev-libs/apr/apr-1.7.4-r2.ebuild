# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="https://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1/${PV%.*}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc old-kernel selinux static-libs +urandom valgrind"

# See bug #815265 for libcrypt dependency
DEPEND="
	virtual/libcrypt:=
	elibc_glibc? ( >=sys-apps/util-linux-2.16 )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-base-policy )
"
DEPEND+=" valgrind? ( dev-debug/valgrind )"
BDEPEND="
	>=dev-build/libtool-2.4.2
	doc? ( app-text/doxygen )
"

DOCS=( CHANGES NOTICE README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.3-skip-known-failing-tests.patch
	"${FILESDIR}"/${PN}-1.7.2-libtool.patch
	"${FILESDIR}"/${PN}-1.7.2-sysroot.patch # bug #385775
	"${FILESDIR}"/${PN}-1.7.2-fix-pkgconfig-libs.patch
	"${FILESDIR}"/${PN}-1.7.2-respect-flags.patch
	"${FILESDIR}"/${PN}-1.7.2-autoconf-2.72.patch
	"${FILESDIR}"/config.layout.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	AT_M4DIR="build" eautoreconf
}

src_configure() {
	tc-export AS CC CPP

	# the libtool script uses bash code in it and at configure time, tries
	# to find a bash shell.  if /bin/sh is bash, it uses that.  this can
	# cause problems for people who switch /bin/sh on the fly to other
	# shells, so just force libtool to use /bin/bash all the time.
	export CONFIG_SHELL="${EPREFIX}"/bin/bash
	export ac_cv_path_SED="$(basename "$(type -P sed)")"
	export ac_cv_path_EGREP="$(basename "$(type -P grep)") -E"
	export ac_cv_path_EGREP_TRADITIONAL="$(basename "$(type -P grep)") -E"
	export ac_cv_path_FGREP="$(basename "$(type -P grep)") -F"
	export ac_cv_path_GREP="$(basename "$(type -P grep)")"
	export ac_cv_path_lt_DD="$(basename "$(type -P dd)")"

	local myconf=(
		--enable-layout=gentoo
		--enable-nonportable-atomics
		--enable-posix-shm
		--enable-threads
		$(use_enable static-libs static)
		$(use_with valgrind)
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
	else
		myconf+=( --with-devrandom=/dev/random )
	fi

	# Avoid libapr containing undefined references (underlinked)
	# undefined reference to `__sync_val_compare_and_swap_8'
	# (May be possible to fix via libatomic linkage in future?)
	# bug #740464
	append-atomic-flags
	if use x86 || [[ ${LIBS} == *atomic* ]] ; then
		myconf+=( --disable-nonportable-atomics )
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
