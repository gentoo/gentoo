# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Another form generation library"
HOMEPAGE="http://docs.pylonsproject.org/projects/deform/en/latest/ https://pypi.python.org/pypi/deform https://github.com/Pylons/deform"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
# tests require zope.deprecation
RESTRICT="test"

RDEPEND=">=dev-python/translationstring-1.1[${PYTHON_USEDEP}]
	>=dev-python/colander-1.0_alpha1[${PYTHON_USEDEP}]
	>=dev-python/peppercorn-0.4[${PYTHON_USEDEP}]
	>=dev-python/chameleon-1.2.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/beautifulsoup:4[${PYTHON_USEDEP}] )"

# Include COPYRIGHT.txt because the license seems to require it.
DOCS=( CHANGES.txt COPYRIGHT.txt README.txt )

src_install() {
	distutils-r1_src_install

	# Install only the .rst source, as sphinx processing requires
	# a theme only available from git that contains hardcoded
	# references to files on https://static.pylonsproject.org/ (so
	# the docs would not actually work offline). Install the
	# source, which is somewhat readable.
	docinto docs
	dodoc docs/*.rst || die
}
