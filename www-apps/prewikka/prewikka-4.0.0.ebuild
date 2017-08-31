# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl"

inherit distutils-r1

DESCRIPTION="Graphical front-end analysis console for the Prelude Framework"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adns"

DEPEND="dev-python/lesscpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/gettext"

RDEPEND="~dev-libs/libprelude-${PV}[python,${PYTHON_USEDEP}]
	~dev-libs/libpreludedb-${PV}[python,${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	media-fonts/font-xfree86-type1
	adns? ( dev-python/twisted[${PYTHON_USEDEP}] )"
