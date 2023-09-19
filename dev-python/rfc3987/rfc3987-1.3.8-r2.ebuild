# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Parsing and validation of URIs (RFC 3986) and IRIs (RFC 3987)"
HOMEPAGE="
	https://github.com/dgerber/rfc3987/
	https://pypi.org/project/rfc3987/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/regex[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

python_test() {
	"${EPYTHON}" -m doctest -v "${S}/${PN}.py" || die
}
