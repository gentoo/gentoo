# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

POWERLINE_PV="2.8.3"
POWERLINE_P="powerline-${POWERLINE_PV}"

DESCRIPTION="OpenType Unicode font with symbols for Powerline/Airline"
HOMEPAGE="https://github.com/powerline/powerline"
SRC_URI="https://github.com/powerline/powerline/archive/refs/tags/${POWERLINE_PV}.tar.gz -> ${POWERLINE_P}.tar.gz"

S="${WORKDIR}/${POWERLINE_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
IUSE=""

FONT_S="${S}/font"
FONT_CONF=( 10-powerline-symbols.conf )
FONT_SUFFIX="otf"

DOCS=( README.rst )
