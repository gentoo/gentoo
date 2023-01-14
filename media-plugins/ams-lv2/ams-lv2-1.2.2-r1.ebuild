# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# version 1.2.2 does not compile with python 3.11
PYTHON_COMPAT=( python3_{9..10} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils python-any-r1

DESCRIPTION="A port of the AMS internal modules to LV2 plugins to create modular synthesizers"
HOMEPAGE="https://github.com/blablack/ams-lv2"
SRC_URI="https://github.com/blablack/ams-lv2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	media-libs/lv2
	media-libs/lvtk[gtk2]
	sci-libs/fftw:3.0
	x11-libs/cairo
	x11-libs/gtk+:2
	virtual/jack"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( LICENSE README.md THANKS )
