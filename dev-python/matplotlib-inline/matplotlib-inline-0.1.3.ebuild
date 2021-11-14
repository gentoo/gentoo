# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Inline Matplotlib backend for Jupyter"
HOMEPAGE="https://github.com/ipython/matplotlib-inline/"
SRC_URI="
	https://github.com/ipython/matplotlib-inline/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]"
