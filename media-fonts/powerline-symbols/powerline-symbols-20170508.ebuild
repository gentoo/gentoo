# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

DESCRIPTION="OpenType Unicode font with symbols for Powerline/Airline"
HOMEPAGE="https://github.com/powerline/powerline"
SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"
# We're redistributing just the (unversioned) font from the upstream repo here

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

FONT_S="${S}"
FONT_SUFFIX="otf"
FONT_CONF=( 10-powerline-symbols.conf )
DOCS="README.rst"
