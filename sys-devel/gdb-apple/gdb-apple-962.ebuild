# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gdb-apple/gdb-apple-962.ebuild,v 1.6 2013/02/09 04:36:22 vapier Exp $

EAPI="3"

inherit eutils flag-o-matic

DESCRIPTION="Apple branch of the GNU Debugger, Xcode Tools 3.1.2"
HOMEPAGE="http://sourceware.org/gdb/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/gdb-${PV}.tar.gz"

LICENSE="APSL-2 GPL-2"
SLOT="0"

KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"

IUSE="nls"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	=dev-db/sqlite-3*"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/gdb-${PV}/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-768-texinfo.patch
	epatch "${FILESDIR}"/${PN}-768-darwin-arch.patch
	epatch "${FILESDIR}"/${PN}-962-darwin8.patch
	epatch "${FILESDIR}"/${PN}-962-darwin64.patch
	epatch "${FILESDIR}"/${PN}-962-demangle.patch

	# for FSF gcc / gcc-apple:42
	sed -e 's/-Wno-long-double//' -i gdb/config/*/macosx.mh
}

src_configure() {
	replace-flags -O? -O2
	econf \
		--disable-werror \
		$(use_enable nls) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" libdir=/nukeme includedir=/nukeme install || die
	rm -r "${D}"/nukeme || die
	rm -Rf "${ED}"/usr/${CHOST} || die
	mv "${ED}"/usr/bin/gdb "${ED}"/
	rm -f "${ED}"/usr/bin/*
	mv "${ED}"/gdb "${ED}"/usr/bin/
}

pkg_postinst() {
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -ge 9 ]] ; then
		elog "Due to increased security measures in 10.5 and up, gdb is"
		elog "not able to get a mach task port when installed by Prefix"
		elog "Portage, unprivileged.  To make gdb fully functional you'll"
		elog "have to perform the following steps:"
		elog "  % sudo chgrp procmod ${EPREFIX}/usr/bin/gdb"
		elog "  % sudo chmod g+s ${EPREFIX}/usr/bin/gdb"
	fi
}
