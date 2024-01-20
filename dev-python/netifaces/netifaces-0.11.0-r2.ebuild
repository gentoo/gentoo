# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Portable network interface information"
HOMEPAGE="
	https://pypi.org/project/netifaces/
	https://alastairs-place.net/projects/netifaces/
	https://github.com/al45tair/netifaces/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.4-remove-osx-fix.patch
	"${FILESDIR}"/${PN}-0.11.0-musl-clang16-null.patch
)

python_test() {
	"${EPYTHON}" test.py || die "Tests failed with ${EPYTHON}"
}
