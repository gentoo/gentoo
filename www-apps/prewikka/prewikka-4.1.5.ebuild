# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ssl"

inherit distutils-r1

DESCRIPTION="Graphical front-end analysis console for the Prelude Framework"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/4.1.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="adns"

DEPEND="dev-python/lesscpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/gettext"

RDEPEND="~dev-libs/libprelude-4.1.0[python,${PYTHON_USEDEP}]
	~dev-libs/libpreludedb-4.1.0[python,${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	media-fonts/font-xfree86-type1
	adns? ( dev-python/twisted[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.5-fix_siteconfig.patch"
	"${FILESDIR}/${PN}-4.1.5-fix_rule_error.patch"
)
