# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb/gdb-7.6.ebuild,v 1.10 2015/05/04 08:19:53 vapier Exp $

EAPI="3"

inherit flag-o-matic eutils

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi
is_cross() { [[ ${CHOST} != ${CTARGET} ]] ; }

RPM=
MY_PV=${PV}
case ${PV} in
*.*.50.*)
	# weekly snapshots
	SRC_URI="ftp://sourceware.org/pub/gdb/snapshots/current/gdb-weekly-${PV}.tar.bz2"
	;;
9999*)
	# live git tree
	EGIT_REPO_URI="git://sourceware.org/git/binutils-gdb.git"
	inherit git-2
	SRC_URI=""
	;;
*)
	# Normal upstream release
	SRC_URI="mirror://gnu/gdb/${P}.tar.bz2
		ftp://sourceware.org/pub/gdb/releases/${P}.tar.bz2"
	;;
esac

PATCH_VER="3"
DESCRIPTION="GNU debugger"
HOMEPAGE="http://sourceware.org/gdb/"
SRC_URI="${SRC_URI} ${PATCH_VER:+mirror://gentoo/${P}-patches-${PATCH_VER}.tar.xz}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="+client expat lzma multitarget nls +python +server test vanilla zlib"

RDEPEND="!dev-util/gdbserver
	>=sys-libs/ncurses-5.2-r2
	sys-libs/readline
	expat? ( dev-libs/expat )
	lzma? ( app-arch/xz-utils )
	python? ( =dev-lang/python-2* )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/yacc
	test? ( dev-util/dejagnu )
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	[[ -n ${RPM} ]] && rpm_spec_epatch "${WORKDIR}"/gdb.spec
	! use vanilla && [[ -n ${PATCH_VER} ]] && EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	strip-linguas -u bfd/po opcodes/po
}

gdb_branding() {
	printf "Gentoo ${PV} "
	if ! use vanilla && [[ -n ${PATCH_VER} ]] ; then
		printf "p${PATCH_VER}"
	else
		printf "vanilla"
	fi
}

src_configure() {
	strip-unsupported-flags

	local myconf=(
		--with-pkgversion="$(gdb_branding)"
		--with-bugurl='http://bugs.gentoo.org/'
		--disable-werror
	)
	local sysroot="${EPREFIX}/usr/${CTARGET}"
	is_cross && myconf+=(
		--with-sysroot="${sysroot}"
		--includedir="${sysroot}/usr/include"
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
			--with-system-readline
			--with-separate-debug-dir="${EPREFIX}"/usr/lib/debug
			$(use_with expat)
			$(use_with lzma)
			$(use_enable nls)
			$(use multitarget && echo --enable-targets=all)
			$(use_with python python "${EPREFIX}/usr/bin/python2")
			$(use_with zlib)
		)
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake check || ewarn "tests failed"
}

src_install() {
	use server && ! use client && cd gdb/gdbserver
	emake DESTDIR="${D}" install || die
	use client && { find "${ED}"/usr -name libiberty.a -delete || die ; }
	cd "${S}"

	# Don't install docs when building a cross-gdb
	if [[ ${CTARGET} != ${CHOST} ]] ; then
		rm -r "${ED}"/usr/share
		return 0
	fi
	# Install it by hand for now:
	# http://sourceware.org/ml/gdb-patches/2011-12/msg00915.html
	# Only install if it exists due to the twisted behavior (see
	# notes in src_configure above).
	[[ -e gdb/gdbserver/gdbreplay ]] && { dobin gdb/gdbserver/gdbreplay || die ; }

	dodoc README
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
