# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Graphical front-end analysis console for the Prelude Framework"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adns"

PYTHON_REQ_USE="ssl"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/lesscpy[${PYTHON_USEDEP}]
	sys-devel/gettext
	dev-python/cheetah[${PYTHON_USEDEP}]"

RDEPEND="dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	adns? ( dev-python/twisted-names[${PYTHON_USEDEP}] )
	media-fonts/font-xfree86-type1
	~dev-libs/libprelude-${PV}[python,${PYTHON_USEDEP}]
	~dev-libs/libpreludedb-${PV}[python,${PYTHON_USEDEP}]"
