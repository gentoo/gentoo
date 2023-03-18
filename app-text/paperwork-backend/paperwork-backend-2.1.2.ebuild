# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Backend part of Paperwork (Python API, no UI)"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/openpaperwork-core[${PYTHON_USEDEP}]
	app-text/openpaperwork-gtk[${PYTHON_USEDEP}]
	app-text/poppler[introspection]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/Levenshtein[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycountry[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/whoosh[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/libpillowfight[${PYTHON_USEDEP}]
		media-libs/libinsane
	)
"

distutils_enable_tests unittest

src_prepare() {
	# remove dep to allow both old python-Levenshtein and new
	# Levenshtein packages
	sed -i -e '/python-Levenshtein/d' setup.py || die
	distutils-r1_src_prepare
}
