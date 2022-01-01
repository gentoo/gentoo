# Copyright 2016-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Personal document indexing system"
HOMEPAGE="https://finestructure.net/xapers/"
SRC_URI="https://finestructure.net/xapers/releases/${P}.tar.gz"
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-text/poppler[utils]
	dev-libs/xapian-bindings[python,${PYTHON_USEDEP}]
	dev-python/pybtex[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	x11-misc/xclip
	x11-misc/xdg-utils"

BDEPEND="test? ( ${RDEPEND} )"

src_test() {
	cd test || die
	./all || die
}
