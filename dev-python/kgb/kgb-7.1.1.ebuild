# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python function spy support for unit tests"
HOMEPAGE="
	https://github.com/beanbaginc/kgb/
	https://pypi.org/project/kgb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest

src_prepare() {
	# remove .dev tag that breaks revdeps
	sed -i -e '/tag_build/d' setup.cfg || die
	distutils-r1_src_prepare
}
