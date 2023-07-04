# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A simple, safe single expression evaluator library"
HOMEPAGE="
	https://github.com/danthedeckie/simpleeval/
	https://pypi.org/project/simpleeval/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests unittest
