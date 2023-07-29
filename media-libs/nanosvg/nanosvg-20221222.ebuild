# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="fltk_${PV:0:4}-${PV:4:2}-${PV:6:2}"

DESCRIPTION="NanoSVG is a simple stupid single-header-file SVG parse."
HOMEPAGE="https://github.com/fltk/nanosvg"
SRC_URI="https://github.com/fltk/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"
