# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Fast, simple object-to-object and broadcast signaling"
HOMEPAGE="
	https://github.com/pallets-eco/blinker/
	https://pypi.org/project/blinker/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

distutils_enable_tests pytest

python_install_all() {
	use doc && HTML_DOCS=( docs/html/. )
	distutils-r1_python_install_all
}
