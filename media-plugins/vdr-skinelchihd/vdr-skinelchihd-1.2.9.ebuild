# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Skin Plugin: skinelchihd"
HOMEPAGE="http://firefly.vdr-developer.org/skinelchihd/index.html"
SRC_URI="https://github.com/FireFlyVDR/vdr-plugin-skinelchihd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-skinelchihd-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="graphicsmagick +imagemagick"
REQUIRED_USE="^^ ( imagemagick graphicsmagick )"

DEPEND=">=media-video/vdr-2.6:=
	imagemagick? ( media-gfx/imagemagick )
	graphicsmagick? ( media-gfx/graphicsmagick )"
RDEPEND="${DEPEND}"
BDEPEND="acct-user/vdr"

src_compile() {
	if use graphicsmagick; then
		emake IMAGELIB=graphicsmagick
	else
		emake
	fi
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/themes
	doins "${S}"/themes/*.theme
	fowners vdr:vdr /etc/vdr -R
}
