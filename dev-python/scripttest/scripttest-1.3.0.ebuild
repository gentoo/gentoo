# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/ScriptTest/
	https://github.com/pypa/scripttest"
# pypi tarball lacks tests
SRC_URI="https://github.com/pypa/scripttest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

distutils_enable_tests pytest
