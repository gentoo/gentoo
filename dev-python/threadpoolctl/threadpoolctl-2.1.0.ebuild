# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Limit the number of threads used in native libs that have their own threadpool"
HOMEPAGE="https://github.com/joblib/threadpoolctl"
SRC_URI="https://github.com/joblib/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

# tests require openmp python bindings...
RESTRICT=test

distutils_enable_tests pytest
