# Copyright 2016-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Personal document indexing system"
HOMEPAGE="https://gitlab.com/wpettersson/xapers/"
SRC_URI="https://gitlab.com/wpettersson/${PN}/-/archive/${PV}/${P}.tar.bz2"
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/${P}-remove-pipes.patch"
)

RDEPEND="app-text/poppler[utils]
	dev-libs/xapian-bindings[python,${PYTHON_USEDEP}]
	dev-python/pybtex[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	x11-misc/xclip
	x11-misc/xdg-utils"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	cd test || die
	./all || die
}
