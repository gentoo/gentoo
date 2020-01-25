# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit eutils flag-o-matic python-single-r1

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

MY_PV=${PV}
case ${PV} in
9999*)
	# live git tree
	EGIT_REPO_URI="git://sourceware.org/git/binutils-gdb.git"
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="+client lzma multitarget nls +python +server source-highlight test vanilla xml"
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
		sys-libs/readline:0=
		lzma? ( app-arch/xz-utils )
		python? ( ${PYTHON_DEPS} )
		xml? ( dev-libs/expat )
		sys-libs/zlib
	)
	source-highlight? (
		dev-util/source-highlight
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

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}"/${PN}-8.3.1-verbose-build.patch
	"${FILESDIR}"/${PN}-8.3.1-gcc-10.patch
)

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
		)
	fi
	if use sparc-solaris || use x86-solaris ; then
		# disable largefile support
		# https://sourceware.org/ml/gdb-patches/2014-12/msg00058.html
		myconf+=( --disable-largefile )
	fi

	econf "${myconf[@]}"
}

src_install() {
	if use server && ! use client; then
		cd gdb/gdbserver || die
	fi
	default
	if use client; then
		find "${ED}"/usr -name libiberty.a -delete || die
	fi
	cd "${S}" || die

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
	[[ -e gdb/gdbserver/gdbreplay ]] && dobin gdb/gdbserver/gdbreplay

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
