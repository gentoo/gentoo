# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils python-any-r1

DESCRIPTION="A port of the AMS internal modules to LV2 plugins to create modular synthesizers"
HOMEPAGE="http://objectivewave.wordpress.com/ams-lv2/"
SRC_URI="https://github.com/blablack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.24.0:2.4
	>=media-libs/lv2-1.10.0
	>=media-libs/lvtk-1.2.0[gtk2]
	>=media-sound/jack-audio-connection-kit-0.120
	>=sci-libs/fftw-3.3.3:3.0
	>=x11-libs/cairo-1.10.0
	>=x11-libs/gtk+-2.24:2"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( LICENSE README.md THANKS )
