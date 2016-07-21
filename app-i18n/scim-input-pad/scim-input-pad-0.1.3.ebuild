# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools

DESCRIPTION="Input pad for SCIM used to input symbols and special characters"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=app-i18n/scim-1.2.0
	>=x11-libs/gtk+-2.6.0:2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.33
	virtual/pkgconfig"

src_prepare() {
	rm "${S}"/m4/intltool.m4 || die
	eautoreconf
}

src_configure() {
	econf $(use_enable nls) || die "Error: econf failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Error: install failed!"
	dodoc ChangeLog README
}

pkg_postinst() {

	elog
	elog "The SCIM input pad should be startable from the SCIM (and Skim)"
	elog "systray icon right click menu. You will have to restart SCIM"
	elog "(or Skim) in order for the menu entry to appear (you may simply"
	elog "restart your X server). If you want to use it immediately, just"
	elog "start the SCIM input pad, using the 'scim-input-pad' command."
	elog
	elog "To use, select the text zone you wish to write in, and just"
	elog "click on the wanted character in the right multilevel tabbed"
	elog "table, from the SCIM Input Pad interface."
	elog
	elog "To add new characters to the tables, see the documentation"
	elog "(README file in /usr/share/doc/${PF})."
	elog

}
