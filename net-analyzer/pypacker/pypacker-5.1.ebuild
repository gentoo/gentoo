# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Fast and simple packet creation and parsing library for Python"
HOMEPAGE="https://gitlab.com/mike01/pypacker"
SRC_URI="https://gitlab.com/mike01/pypacker/-/archive/v${PV}/pypacker-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DOCS=( AUTHORS CHANGES HACKING README.md )

python_test() {
	"${EPYTHON}" tests/test_pypacker.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
