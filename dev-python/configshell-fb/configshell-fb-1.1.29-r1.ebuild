# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Python library for building configuration shells"
HOMEPAGE="
	https://github.com/open-iscsi/configshell-fb/
	https://pypi.org/project/configshell-fb/
"
SRC_URI="
	https://github.com/open-iscsi/configshell-fb/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/open-iscsi/configshell-fb/commit/f3ac914861bd605e3d634aeeb5e706abdbd39259.patch
		-> ${P}-replace-getargspec-1.patch
	https://github.com/open-iscsi/configshell-fb/commit/50d5ffe9f213a53588cec88c9919c816b3fa7736.patch
		-> ${P}-replace-getargspec-2.patch
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
"

PATCHES=(
	# Python3.11 fixes of deprecated getargspec function taken from upstream:
	# - https://github.com/open-iscsi/configshell-fb/pull/64
	"${DISTDIR}/${P}-replace-getargspec-1.patch"
	# - https://github.com/open-iscsi/configshell-fb/pull/65
	"${DISTDIR}/${P}-replace-getargspec-2.patch"
)

python_test() {
	"${EPYTHON}" examples/myshell || die "Test failed with ${EPYTHON}"
}
