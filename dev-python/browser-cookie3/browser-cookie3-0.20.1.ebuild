# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Loads cookies from your browser into a cookiejar object"
HOMEPAGE="
	https://github.com/borisbabic/browser_cookie3/
	https://pypi.org/project/browser-cookie3/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests require selenium, browsers, and are aimed for one-shot validation of
# cookie file format validation for documentation
RESTRICT="test"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/lz4[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# make cryptodome-friendly
	sed -i -e 's:pycryptodomex:pycryptodome:' setup.py || die
	sed -i -e 's:Cryptodome:Crypto:g' browser_cookie3/__init__.py || die

	distutils-r1_python_prepare_all
}
