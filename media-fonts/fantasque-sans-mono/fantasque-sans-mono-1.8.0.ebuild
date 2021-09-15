# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A font family with a great monospaced variant for programmers"
HOMEPAGE="https://github.com/belluzj/fantasque-sans"
SRC_URI="https://github.com/belluzj/fantasque-sans/releases/download/v${PV}/FantasqueSansMono-Normal.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

FONT_S="${S}/OTF"
FONT_SUFFIX="otf"
