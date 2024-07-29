# Copyright 2010-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="TakaoFonts_${PV}"

DESCRIPTION="A community developed derivatives of IPA Fonts"
HOMEPAGE="https://launchpad.net/takao-fonts"
SRC_URI="https://launchpad.net/${PN}/trunk/15.03/+download/${MY_P}.tar.xz"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE=""
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"

FONT_CONF=( "${FILESDIR}/66-${PN}.conf" )
FONT_SUFFIX="ttf"
