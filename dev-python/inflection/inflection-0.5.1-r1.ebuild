# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A port of Ruby on Rails' inflector to Python"
HOMEPAGE="
	https://github.com/jpvanhal/inflection/
	https://pypi.org/project/inflection/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_sphinx docs
distutils_enable_tests pytest
