# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

MY_PN="Flask-Babel"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="i18n and l10n support for Flask based on Babel and pytz"
HOMEPAGE="https://pythonhosted.org/Flask-Babel/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/speaklater-1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
