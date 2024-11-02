# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A fast and simple micro-framework for small web-applications"
HOMEPAGE="
	https://bottlepy.org/
	https://github.com/bottlepy/bottle/
	https://pypi.org/project/bottle/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "Templating support" dev-python/mako
}
