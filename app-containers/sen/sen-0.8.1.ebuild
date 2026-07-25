# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Terminal User Interface for docker engine"
HOMEPAGE="https://github.com/TomasTomecek/sen"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/urwid-2.6.14[${PYTHON_USEDEP}]
	dev-python/urwidtrees[${PYTHON_USEDEP}]
	>=dev-python/docker-7.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.4[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/flexmock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-0.8.1-include-subpackages.patch"
	"${FILESDIR}/${PN}-0.8.1-urwid-import.patch"
)

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r docs
}
