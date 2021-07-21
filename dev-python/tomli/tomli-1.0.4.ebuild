# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A lil' TOML parser"
HOMEPAGE="
	https://pypi.org/project/tomli/
	https://github.com/hukkin/tomli/"
SRC_URI="
	https://github.com/hukkin/tomli/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"

BDEPEND="
	test? ( dev-python/python-dateutil[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
