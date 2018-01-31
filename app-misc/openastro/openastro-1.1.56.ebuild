# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 python3_6 )

inherit distutils-r1

MY_PN=${PN}.org

DESCRIPTION="A fully-featured Open Source Astrology Program"
HOMEPAGE="http://openastro.org"
SRC_URI="http://ppa.launchpad.net/pellesimon/ubuntu/pool/main/o/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg png"

DEPEND="
	app-misc/openastro-data[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pycairo[svg(+),${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyswisseph[${PYTHON_USEDEP}]
	gnome-base/librsvg:2[introspection]
	x11-libs/gtk+:3[introspection]"
RDEPEND="${DEPEND}
	jpeg? ( media-gfx/imagemagick[jpeg,svg] )
	png? ( media-gfx/imagemagick[png,svg] )"

S=${WORKDIR}/${MY_PN}-${PV}
