# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb-apple/gdb-apple-1708.ebuild,v 1.2 2013/02/09 04:36:22 vapier Exp $

EAPI="3"

inherit eutils flag-o-matic

APPLE_PV=${PV}
DESCRIPTION="Apple branch of the GNU Debugger, Developer Tools 4.2"
HOMEPAGE="http://sourceware.org/gdb/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/gdb-${APPLE_PV}.tar.gz"

LICENSE="APSL-2 GPL-2"
SLOT="0"

KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"

IUSE="nls"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	=dev-db/sqlite-3*"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/gdb-${APPLE_PV}/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-no-global-gdbinit.patch
	epatch "${FILESDIR}"/${PN}-768-texinfo.patch
	epatch "${FILESDIR}"/${PN}-1518-darwin8-9.patch
	epatch "${FILESDIR}"/${PN}-1705-darwin8-10.patch
	[[ ${CHOST} == *-darwin8 ]] && epatch "${FILESDIR}"/${PN}-1518-darwin8.patch
}

src_configure() {
	replace-flags -O? -O2
	econf \
		--disable-werror \
		--disable-debug-symbols-framework \
		$(use_enable nls) \
		|| die
}

src_compile() {
	# unable to work around parallel make issue
	emake -j2 || die
}

src_install() {
	emake -j2 DESTDIR="${D}" libdir=/nukeme includedir=/nukeme install || die
	rm -R "${D}"/nukeme || die
	rm -Rf "${ED}"/usr/${CHOST} || die
	mv "${ED}"/usr/bin/gdb "${ED}"/
	rm -f "${ED}"/usr/bin/*
	mv "${ED}"/gdb "${ED}"/usr/bin/
}

pkg_postinst() {
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -ge 9 ]] ; then
		ewarn "Due to increased security measures in 10.5 and up, gdb is"
		ewarn "not able to get a mach task port when installed by Prefix"
		ewarn "Portage, unprivileged.  To make gdb fully functional you'll"
		ewarn "have to perform the following steps:"
		ewarn "  % sudo chgrp procmod ${EPREFIX}/usr/bin/gdb"
		ewarn "  % sudo chmod g+s ${EPREFIX}/usr/bin/gdb"
	fi
	if use x86-macos || use x64-macos ; then
		einfo "FSF gdb works on Intel-based OSX platforms, sometimes even"
		einfo "better than gdb-apple.  You can consider installing FSF gdb"
		einfo "instead of gdb-apple, since the FSF version is surely more"
		einfo "advanced than this old 6.8 version modified by Apple."
	fi
}
