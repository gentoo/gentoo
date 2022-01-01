# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} )

inherit distutils-r1 virtualx

DESCRIPTION="Python interface to DBus notifications."
HOMEPAGE="https://bitbucket.org/takluyver/pynotify2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="examples"

RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]"
BDEPEND="test? ( sys-apps/dbus[X] )"

python_test() {
	virtx ${EPYTHON} test_notify2.py
}

python_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
	distutils-r1_python_install_all
}
