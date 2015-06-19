# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/xdx/xdx-2.4.2.ebuild,v 1.10 2014/08/10 21:04:10 slyfox Exp $

EAPI="5"

inherit eutils

DESCRIPTION="a GTK+ TCP/IP DX-cluster and ON4KST chat client"
HOMEPAGE="http://www.ibiblio.org/pub/linux/apps/ham"
SRC_URI="http://www.ibiblio.org/pub/linux/apps/ham/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.12:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	# fix for bug #326627 - deprecated macro in gtk+ from 2.20 on
	if has_version ">=x11-libs/gtk+-2.20" ; then
		epatch "${FILESDIR}"/${PN}-gtk-2.20.patch
	fi

	# Drop DEPRECATED flags, bug #391091
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		src/Makefile.am src/Makefile.in || die

	# Fix desktop file
	sed -i -e "s/Network;HamRadio/Network;HamRadio;/" Xdx.desktop || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elog "To use the rig control feature, install media-libs/hamlib"
	elog "and enable hamlib in the Preferences dialog. (no need for recompile)"
}
