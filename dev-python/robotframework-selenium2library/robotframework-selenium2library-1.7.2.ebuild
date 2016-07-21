# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Web testing library for Robot Framework"
HOMEPAGE="https://github.com/rtomac/robotframework-selenium2library/
	https://pypi.python.org/pypi/robotframework-selenium2library/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/selenium-2.32.0[${PYTHON_USEDEP}]
		>=dev-python/decorator-3.3.2[${PYTHON_USEDEP}]
		>=dev-python/robotframework-2.6.0[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.8.1[${PYTHON_USEDEP}]"

src_prepare() {
	# don't use bundled setuptools
	sed -e '/use_setuptools()/d' \
		-e '/ez_setup/d' \
		-i setup.py || die
}

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	use doc && local HTML_DOCS=( doc/Selenium2Library.html )

	distutils-r1_python_install_all
}
