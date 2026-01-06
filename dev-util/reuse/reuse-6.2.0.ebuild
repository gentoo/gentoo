# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Manage license information according to the SPDX standard"
HOMEPAGE="https://reuse.software/
	https://codeberg.org/fsfe/reuse-tool"
MY_PN="${PN}-tool"
SRC_URI="https://codeberg.org/fsfe/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-3+ CC-BY-SA-4.0 CC0-1.0 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/boolean-py-3.8[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/license-expression-21.6.14[${PYTHON_USEDEP}]
	>=dev-python/python-debian-0.1.48[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.8[${PYTHON_USEDEP}]
	>=dev-python/attrs-23.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.0[${PYTHON_USEDEP}]"

BDEPEND="sys-devel/gettext
	test? (
		dev-vcs/git
		dev-vcs/mercurial
		dev-python/freezegun[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CHANGELOG.md README.md )

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	">=dev-python/myst-parser-2.0.0" \
	">=dev-python/sphinxcontrib-apidoc-0.3.0" \
	">=dev-python/furo-2023.3.27"

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests
}
