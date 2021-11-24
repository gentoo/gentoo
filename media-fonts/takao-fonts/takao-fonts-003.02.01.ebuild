# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="${PN}-ttf-${PV}"

DESCRIPTION="A community developed derivatives of IPA Fonts"
HOMEPAGE="https://launchpad.net/takao-fonts"
SRC_URI="https://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${MY_P}.tar.gz"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE=""
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"

FONT_CONF=( "${FILESDIR}/66-${PN}.conf" )
FONT_SUFFIX="ttf"
