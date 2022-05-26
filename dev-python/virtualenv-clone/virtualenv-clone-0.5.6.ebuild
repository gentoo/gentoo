# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A script for cloning a non-relocatable virtualenv"
HOMEPAGE="https://github.com/edwardgeorge/virtualenv-clone/"
SRC_URI="
	https://github.com/edwardgeorge/virtualenv-clone/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

BDEPEND="
	test? ( dev-python/virtualenv[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
