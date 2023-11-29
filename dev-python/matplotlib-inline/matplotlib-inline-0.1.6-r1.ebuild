# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Inline Matplotlib backend for Jupyter"
HOMEPAGE="
	https://github.com/ipython/matplotlib-inline/
	https://pypi.org/project/matplotlib-inline/
"
SRC_URI="
	https://github.com/ipython/matplotlib-inline/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

# Although in theory we could depend on matplotlib, upstream does not.
# This is because the sole purpose of the package is to be loaded by
# ipython (also not a dependency!) as a response to interactive use of
# the "%matplotlib" magic.
#
# In order to be seamless and straightforward, this backend is always
# installed and just requires users using matplotlib, to install
# matplotlib before importing and using it.
RDEPEND="
	dev-python/traitlets[${PYTHON_USEDEP}]
"
