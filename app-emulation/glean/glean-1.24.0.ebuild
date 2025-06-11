# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools

inherit edo distutils-r1 pypi udev

DESCRIPTION="Simple program to write static config from config-drive"
HOMEPAGE="https://opendev.org/opendev/glean"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/pbr[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/testscenarios-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.3.0[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.24.0-support-gentoo-install.patch
)

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all
	edo "${EPYTHON}" "${S}/glean/install.py"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
