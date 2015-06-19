# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/guessit/guessit-0.5.4.ebuild,v 1.4 2015/04/08 08:05:01 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python library that tries to extract as much information as possible from a filename"
HOMEPAGE="http://guessit.readthedocs.org/"
SRC_URI="https://github.com/wackou/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-python3.patch
	"${FILESDIR}"/${P}-tests.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	#Patch fails to create this file, so use touch
	touch tests/__init__.py || die
}

python_test() {
	PYTHONPATH="${S}/tests" esetup.py test
}
