# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="Fira"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Default monospaced typeface for FirefoxOS, designed for legibility"
HOMEPAGE="https://mozilla.github.io/Fira"
SRC_URI="https://github.com/mozilla/Fira/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="+otf ttf"

REQUIRED_USE="|| ( otf ttf )"

S="${WORKDIR}/${MY_P}"

DOCS=( README.md LICENSE )

src_prepare() {
	default

	use ttf && { rm "${S}"/ttf/FiraMono-*.ttf || die; }
	use otf && { rm "${S}"/otf/FiraMono*.otf || die; }
}

src_install() {
	use otf && { FONT_S="${S}/otf"; FONT_SUFFIX="otf"; }
	use ttf && { FONT_S="${S}/ttf"; FONT_SUFFIX="ttf"; }

	font_src_install
	einstalldocs
}
