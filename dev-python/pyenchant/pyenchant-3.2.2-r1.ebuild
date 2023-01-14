# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Enchant spellchecking system"
HOMEPAGE="
	https://github.com/pyenchant/pyenchant/
	https://pypi.org/project/pyenchant/
"
SRC_URI="
	https://github.com/pyenchant/pyenchant/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	app-text/enchant:*
"
BDEPEND="
	test? (
		app-dicts/myspell-en
	)
"

distutils_enable_tests pytest
