# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Commonly needed Python modules used by Python software developed at OSRF"
HOMEPAGE="https://github.com/osrf/osrf_pycommon"
SRC_URI="https://github.com/osrf/osrf_pycommon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# linting is something upstreams do
	# for us, it either means unneeded deps or breakage due to changes
	tests/test_code_format.py
)
