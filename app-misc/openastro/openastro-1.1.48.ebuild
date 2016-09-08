# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN}.org

DESCRIPTION="A fully-featured Open Source Astrology Program"
HOMEPAGE="http://openastro.org"
SRC_URI="http://ppa.launchpad.net/pellesimon/ubuntu/pool/main/o/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3+"
SLOT="0"

IUSE="jpeg png"

DEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pycairo[svg,${PYTHON_USEDEP}]
	dev-python/librsvg-python[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyswisseph[${PYTHON_USEDEP}]
	app-misc/openastro-data[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	jpeg? ( media-gfx/imagemagick[jpeg,svg] )
	png? ( media-gfx/imagemagick[png,svg] )"

S=${WORKDIR}/${MY_PN}-${PV}
