# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Collection of free fonts for Thai"
HOMEPAGE="https://linux.thai.net/projects/thaifonts-scalable"
SRC_URI="https://github.com/tlwg/fonts-tlwg/releases/download/v${PV}/ttf-tlwg-${PV}.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/ttf-tlwg-${PV}"

LICENSE="|| ( GPL-2-with-font-exception GPL-3-with-font-exception )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

FONT_CONF=(
	fontconfig/conf.avail/64-01-tlwg-kinnari.conf
	fontconfig/conf.avail/64-02-tlwg-norasi.conf
	fontconfig/conf.avail/64-10-tlwg-loma.conf
	fontconfig/conf.avail/64-11-tlwg-waree.conf
	fontconfig/conf.avail/64-13-tlwg-garuda.conf
	fontconfig/conf.avail/64-14-tlwg-umpush.conf
	fontconfig/conf.avail/64-15-laksaman.conf
	fontconfig/conf.avail/64-21-tlwg-typo.conf
	fontconfig/conf.avail/64-22-tlwg-typist.conf
	fontconfig/conf.avail/64-23-tlwg-mono.conf
	fontconfig/conf.avail/89-tlwg-garuda-synthetic.conf
	fontconfig/conf.avail/89-tlwg-kinnari-synthetic.conf
	fontconfig/conf.avail/89-tlwg-laksaman-synthetic.conf
	fontconfig/conf.avail/89-tlwg-umpush-synthetic.conf
)
FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst
	elog "  64-*.conf enable basic support"
	elog "  89-*-synthetic.conf emulate the Thai font of Windows"
}
