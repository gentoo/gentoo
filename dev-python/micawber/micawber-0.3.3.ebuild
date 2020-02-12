# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="A small library for extracting rich content from urls"
HOMEPAGE="https://github.com/coleifer/micawber/"
SRC_URI="https://github.com/coleifer/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

EXAMPLES=( examples/ )
PATCHES=( "${FILESDIR}"/${PN}-0.3.2-remove-examples-from-setup.py.patch ) #555250

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r docs
}
