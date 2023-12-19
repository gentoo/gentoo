# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Manage license information according to the SPDX standard"
HOMEPAGE="https://reuse.software/
	https://github.com/fsfe/reuse-tool"
MY_PN="${PN}-tool"
SRC_URI="https://github.com/fsfe/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3+ CC-BY-SA-4.0 CC0-1.0 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/boolean-py-3.8[${PYTHON_USEDEP}]
	>=dev-python/jinja-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/license-expression-1.0[${PYTHON_USEDEP}]
	>=dev-python/python-debian-0.1.48[${PYTHON_USEDEP}]"

BDEPEND="sys-devel/gettext
	test? (
		dev-vcs/git
		dev-vcs/mercurial
	)"

PATCHES=( "${FILESDIR}/reuse-2.1.0_docs.patch" )

DOCS=( AUTHORS.rst CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md README.md )

distutils_enable_tests pytest

# dev-python/sphinx-autodoc-typehints will be dropped after 2.1.0
distutils_enable_sphinx docs \
	">=dev-python/furo-2023.3.27" \
	">=dev-python/recommonmark-0.7.1" \
	">=dev-python/sphinxcontrib-apidoc-0.3.0" \
	">=dev-python/sphinx-autodoc-typehints-1.12.0"

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests
}
