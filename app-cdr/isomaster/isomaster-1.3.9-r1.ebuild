# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/isomaster/isomaster-1.3.9-r1.ebuild,v 1.4 2012/05/03 07:51:48 jdhore Exp $

EAPI=4
inherit eutils fdo-mime toolchain-funcs

DESCRIPTION="Graphical CD image editor for reading, modifying and writing ISO images"
HOMEPAGE="http://littlesvr.ca/isomaster"
SRC_URI="http://littlesvr.ca/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="nls"

RDEPEND=">=dev-libs/iniparser-3.0.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	myisoconf=(
		DEFAULT_EDITOR=leafpad
		MYDOCPATH=/usr/share/doc/${PF}/bkisofs
		USE_SYSTEM_INIPARSER=1
		PREFIX=/usr
		)

	use nls || myisoconf+=( WITHOUT_NLS=1 )
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	epatch "${FILESDIR}"/${P}-iniparser-3.0.0.patch #399629
	rm -R iniparser-2.17 || die
}

src_configure() { :; } #274361

src_compile() {
	tc-export CC
	emake "${myisoconf[@]}"
}

_apply_linguas() {
	mv "${D}"/usr/share/locale{,_ALL} || die
	dodir /usr/share/locale || die
	for lingua in ${LINGUAS}; do
		[[ -d "${D}"/usr/share/locale_ALL/${lingua} ]] || break
		mv "${D}"/usr/share/{locale_ALL/${lingua},locale/} || die
	done
	rm -R "${D}"/usr/share/locale_ALL || die
}

src_install() {
	emake "${myisoconf[@]}" DESTDIR="${D}" install
	dodoc {CHANGELOG,CREDITS,README,TODO}.TXT *.txt

	_apply_linguas  # bug 402679
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
