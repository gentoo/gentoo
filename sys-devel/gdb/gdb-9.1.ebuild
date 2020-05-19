# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit eutils flag-o-matic python-single-r1 toolchain-funcs

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

case ${PV} in
9999*)
	# live git tree
	EGIT_REPO_URI="https://sourceware.org/git/binutils-gdb.git"
	inherit git-r3
	SRC_URI=""
	;;
*.*.50.2???????)
	# weekly snapshots
	SRC_URI="ftp://sourceware.org/pub/gdb/snapshots/current/gdb-weekly-${PV}.tar.xz"
	;;
*)
	# Normal upstream release
	SRC_URI="mirror://gnu/gdb/${P}.tar.xz
		ftp://sourceware.org/pub/gdb/releases/${P}.tar.xz"
	;;
esac

PATCH_VER=""
PATCH_DEV=""
DESCRIPTION="GNU debugger"
HOMEPAGE="https://sourceware.org/gdb/"
SRC_URI="${SRC_URI}
	${PATCH_DEV:+https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${P}-patches-${PATCH_VER}.tar.xz}
	${PATCH_VER:+mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz}
"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="+client lzma multitarget nls +python +server source-highlight test vanilla xml xxhash"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	|| ( client server )
"

# ia64 kernel crashes when gdb testsuite is running
# hppa kernel crashes when gdb testsuite is running
RESTRICT="
	hppa? ( test )
	ia64? ( test )

	!test? ( test )
"

RDEPEND="
	client? (
		dev-libs/mpfr:0=
		>=sys-libs/ncurses-5.2-r2:0=
		>=sys-libs/readline-7:0=
		lzma? ( app-arch/xz-utils )
		python? ( ${PYTHON_DEPS} )
		xml? ( dev-libs/expat )
		sys-libs/zlib
	)
	source-highlight? (
		dev-util/source-highlight
	)
	xxhash? (
		dev-libs/xxhash
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-apps/texinfo
	client? (
		virtual/yacc
		test? ( dev-util/dejagnu )
		nls? ( sys-devel/gettext )
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-8.3.1-verbose-build.patch
	"${FILESDIR}"/${PN}-9.1-ia64.patch
)

GDB_BUILD_DIR="${WORKDIR}"/${P}-build

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	strip-linguas -u bfd/po opcodes/po
}

gdb_branding() {
	printf "Gentoo ${PV} "
	if ! use vanilla && [[ -n ${PATCH_VER} ]] ; then
		printf "p${PATCH_VER}"
	else
		printf "vanilla"
	fi
	[[ -n ${EGIT_COMMIT} ]] && printf " ${EGIT_COMMIT}"
}

src_configure() {
	strip-unsupported-flags

	local myconf=(
		# portage's econf() does not detect presence of --d-d-t
		# because it greps only top-level ./configure. But not
		# gnulib's or gdb's configure.
		--disable-dependency-tracking

		--with-pkgversion="$(gdb_branding)"
		--with-bugurl='https://bugs.gentoo.org/'
		--disable-werror
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{binutils,etc,gas,gold,gprof,ld}
	)
	local sysroot="${EPREFIX}/usr/${CTARGET}"
	is_cross && myconf+=(
		--with-sysroot="${sysroot}"
		--includedir="${sysroot}/usr/include"
		--with-gdb-datadir="\${datadir}/gdb/${CTARGET}"
	)

	if use server && ! use client ; then
		# just configure+build in the gdbserver subdir to speed things up
		cd gdb/gdbserver
		myconf+=( --program-transform-name='' )
	else
		# gdbserver only works for native targets (CHOST==CTARGET).
		# it also doesn't support all targets, so rather than duplicate
		# the target list (which changes between versions), use the
		# "auto" value when things are turned on.
		is_cross \
			&& myconf+=( --disable-gdbserver ) \
			|| myconf+=( $(use_enable server gdbserver auto) )
	fi

	if ! ( use server && ! use client ) ; then
		# if we are configuring in the top level, then use all
		# the additional global options
		myconf+=(
			--enable-64-bit-bfd
			--disable-install-libbfd
			--disable-install-libiberty
			# Disable guile for now as it requires guile-2.x #562902
			--without-guile
			# This only disables building in the readline subdir.
			# For gdb itself, it'll use the system version.
			--disable-readline
			--with-system-readline
			# This only disables building in the zlib subdir.
			# For gdb itself, it'll use the system version.
			--without-zlib
			--with-system-zlib
			--with-separate-debug-dir="${EPREFIX}"/usr/lib/debug
			$(use_with xml expat)
			$(use_with lzma)
			$(use_enable nls)
			$(use_enable source-highlight)
			$(use multitarget && echo --enable-targets=all)
			$(use_with python python "${EPYTHON}")
			$(use_with xxhash)
		)
	fi
	if use sparc-solaris || use x86-solaris ; then
		# disable largefile support
		# https://sourceware.org/ml/gdb-patches/2014-12/msg00058.html
		myconf+=( --disable-largefile )
	fi

	# source-highlight is detected with pkg-config: bug #716558
	export ac_cv_path_pkg_config_prog_path="$(tc-getPKG_CONFIG)"

	mkdir "${GDB_BUILD_DIR}" || die
	pushd "${GDB_BUILD_DIR}" || die
		ECONF_SOURCE=${S}
		econf "${myconf[@]}"
	popd
}

src_compile() {
	emake -C "${GDB_BUILD_DIR}"
}

src_test() {
	emake -C "${GDB_BUILD_DIR}" check
}

src_install() {
	if use server && ! use client; then
		emake -C "${GDB_BUILD_DIR}"/gdb/gdbserver DESTDIR="${D}" install
	else
		emake -C "${GDB_BUILD_DIR}" DESTDIR="${D}" install
	fi

	if use client; then
		find "${ED}"/usr -name libiberty.a -delete || die
	fi

	# Delete translations that conflict with binutils-libs. #528088
	# Note: Should figure out how to store these in an internal gdb dir.
	if use nls ; then
		find "${ED}" \
			-regextype posix-extended -regex '.*/(bfd|opcodes)[.]g?mo$' \
			-delete || die
	fi

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -rf "${ED}"/usr/share/{doc,info,locale} || die
		local f
		for f in "${ED}"/usr/share/man/*/* ; do
			if [[ ${f##*/} != ${CTARGET}-* ]] ; then
				mv "${f}" "${f%/*}/${CTARGET}-${f##*/}" || die
			fi
		done
		return 0
	fi
	# Install it by hand for now:
	# https://sourceware.org/ml/gdb-patches/2011-12/msg00915.html
	# Only install if it exists due to the twisted behavior (see
	# notes in src_configure above).
	[[ -e "${GDB_BUILD_DIR}"/gdb/gdbserver/gdbreplay ]] && dobin "${GDB_BUILD_DIR}"/gdb/gdbserver/gdbreplay

	if use client ; then
		docinto gdb
		dodoc gdb/CONTRIBUTE gdb/README gdb/MAINTAINERS \
			gdb/NEWS gdb/ChangeLog gdb/PROBLEMS
	fi
	docinto sim
	dodoc sim/{ChangeLog,MAINTAINERS,README-HACKING}
	if use server ; then
		docinto gdbserver
		dodoc gdb/gdbserver/{ChangeLog,README}
	fi

	if [[ -n ${PATCH_VER} ]] ; then
		dodoc "${WORKDIR}"/extra/gdbinit.sample
	fi

	# Remove shared info pages
	rm -f "${ED}"/usr/share/info/{annotate,bfd,configure,standards}.info*

	# gcore is part of ubin on freebsd
	if [[ ${CHOST} == *-freebsd* ]]; then
		rm "${ED}"/usr/bin/gcore || die
	fi

	if use python; then
		python_optimize "${ED}"/usr/share/gdb/python/gdb
	fi
}

pkg_postinst() {
	# portage sucks and doesnt unmerge files in /etc
	rm -vf "${EROOT}"/etc/skel/.gdbinit

	if use prefix && [[ ${CHOST} == *-darwin* ]] ; then
		ewarn "gdb is unable to get a mach task port when installed by Prefix"
		ewarn "Portage, unprivileged.  To make gdb fully functional you'll"
		ewarn "have to perform the following steps:"
		ewarn "  % sudo chgrp procmod ${EPREFIX}/usr/bin/gdb"
		ewarn "  % sudo chmod g+s ${EPREFIX}/usr/bin/gdb"
	fi
}
