# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="sphinxcontrib_github_alt"

DESCRIPTION="Link to GitHub issues, pull requests, commits and users from Sphinx docs"
HOMEPAGE="https://github.com/jupyter/sphinxcontrib_github_alt"
SRC_URI="https://github.com/jupyter/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}"-1.1-setup.py.patch
	"${FILESDIR}/${PN}"-1.0-init.py.patch
)

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	mv "${WORKDIR}/${MY_PN}-${PV}"/sphinxcontrib_github_alt.py "${WORKDIR}/${MY_PN}-${PV}/${MY_PN}/" || die
}
