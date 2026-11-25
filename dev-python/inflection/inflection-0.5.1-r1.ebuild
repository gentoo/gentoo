# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A port of Ruby on Rails' inflector to Python"
HOMEPAGE="
	https://github.com/jpvanhal/inflection/
	https://pypi.org/project/inflection/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"

distutils_enable_sphinx docs
EPYTEST_PLUGINS=()
distutils_enable_tests pytest
