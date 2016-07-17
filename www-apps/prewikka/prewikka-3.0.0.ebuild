# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Graphical front-end analysis console for the Prelude Framework"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adns"

DEPEND="dev-python/setuptools
	dev-python/lesscpy
	sys-devel/gettext"

RDEPEND="dev-python/cheetah[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	adns? ( dev-python/twisted-names[${PYTHON_USEDEP}] )
	media-fonts/font-xfree86-type1
	dev-libs/libprelude[${PYTHON_USEDEP}]
	dev-libs/libpreludedb[${PYTHON_USEDEP}]"
