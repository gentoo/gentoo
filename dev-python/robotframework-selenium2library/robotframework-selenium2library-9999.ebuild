# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/rtomac/robotframework-selenium2library.git"

DESCRIPTION="Web testing library for Robot Framework"
HOMEPAGE="https://github.com/rtomac/robotframework-selenium2library/
	http://pypi.python.org/pypi/robotframework-selenium2library/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/selenium-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.3.2[${PYTHON_USEDEP}]
	>=dev-python/robotframework-2.6.0[${PYTHON_USEDEP}]"

DOCS=( BUILD.rst CHANGES.rst README.rst )

src_prepare() {
	# don't use bundled setuptools
	sed -e '/use_setuptools()/d' \
		-e '/ez_setup/d' \
		-i setup.py || die
}
