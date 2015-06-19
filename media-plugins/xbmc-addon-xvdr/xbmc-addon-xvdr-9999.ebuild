# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xbmc-addon-xvdr/xbmc-addon-xvdr-9999.ebuild,v 1.3 2014/01/23 10:34:05 hd_brummy Exp $

EAPI="4"

inherit git-2 autotools multilib

EGIT_REPO_URI="git://github.com/pipelka/xbmc-addon-xvdr.git"

DESCRIPTION="XBMC addon: add VDR (http://www.tvdr.de/) as a TV/PVR Backend"
HOMEPAGE="https://github.com/pipelka/xbmc-addon-xvdr"
SRC_URI=""
KEYWORDS=""
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --prefix=/usr/$(get_libdir)/xbmc
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_info() {
	einfo "This add-on requires the installed "media-lugins/vdr-xvdr" plugin on the VDR server."
	einfo "VDR itself dosn't need any patches or modification to use all the current features."
	einfo "IMPORTANT:"
	einfo "Please disable *all* PVR addons *before* running the XVDR addon!"
}
