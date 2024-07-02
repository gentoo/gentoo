# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 virtualx pypi

DESCRIPTION="Python interface to DBus notifications"
HOMEPAGE="
	https://bitbucket.org/takluyver/pynotify2/
	https://pypi.org/project/notify2/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="examples"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pygobject[${PYTHON_USEDEP}]
		sys-apps/dbus[X]
		x11-libs/gdk-pixbuf[introspection]
		virtual/notification-daemon
	)
"

distutils_enable_tests unittest

python_test() {
	virtx eunittest
}

python_install_all() {
	if use examples; then
		rm examples/notify2.py || die
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
