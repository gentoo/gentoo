# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Limit the number of threads used in native libs that have their own threadpool"
HOMEPAGE="https://github.com/joblib/threadpoolctl"
SRC_URI="https://github.com/joblib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
