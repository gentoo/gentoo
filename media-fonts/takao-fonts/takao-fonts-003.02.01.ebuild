# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

MY_P="${PN}-ttf-${PV}"
DESCRIPTION="A community developed derivatives of IPA Fonts"
HOMEPAGE="https://launchpad.net/takao-fonts"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_SUFFIX="ttf"
FONT_S="${S}"
FONT_CONF=( "${FILESDIR}/66-${PN}.conf" )

DOCS="ChangeLog README*"

# Only installs fonts
RESTRICT="strip binchecks"
