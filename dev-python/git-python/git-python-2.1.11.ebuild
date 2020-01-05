# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="GitPython"
MY_PV="${PV/_rc/.RC}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="https://github.com/gitpython-developers/GitPython https://pypi.org/project/GitPython/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# Tests only work with the GitPython repo
RESTRICT="test"

RDEPEND="
	dev-vcs/git
	>=dev-python/gitdb2-2.0.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ddt-1.1.1[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"
