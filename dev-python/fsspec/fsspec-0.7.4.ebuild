# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

MY_P=filesystem_spec-${PV}

DESCRIPTION="A specification that python filesystems should adhere to"
HOMEPAGE="https://github.com/intake/filesystem_spec/
	https://pypi.org/project/fsspec/"
SRC_URI="
	https://github.com/intake/filesystem_spec/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

distutils_enable_tests pytest

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	distutils-r1_src_test
}
