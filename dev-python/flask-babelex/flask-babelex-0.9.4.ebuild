# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="Flask-BabelEx"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Adds i18n/l10n support to Flask applications"
HOMEPAGE="https://github.com/mrjoes/flask-babelex https://pypi.org/project/Flask-BabelEx/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	>=dev-python/Babel-1[${PYTHON_USEDEP}]
	>=dev-python/speaklater-1.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.5[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	dev-python/flask-sphinx-themes

PATCHES=( "${FILESDIR}/${PN}-0.9.3-tests-fix.patch" )

python_test() {
	cd tests || die
	eunittest
}
