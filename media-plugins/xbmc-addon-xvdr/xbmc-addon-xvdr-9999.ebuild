# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib git-r3

DESCRIPTION="XBMC addon: add VDR (http://www.tvdr.de/) as a TV/PVR Backend"
HOMEPAGE="https://github.com/pipelka/xbmc-addon-xvdr"
EGIT_REPO_URI="https://github.com/pipelka/xbmc-addon-xvdr.git"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default
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
