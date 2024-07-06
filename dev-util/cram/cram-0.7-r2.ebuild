# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Functional testing framework for command line applications"
HOMEPAGE="https://bitheap.org/cram/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv x86"

python_test() {
	"${EPYTHON}" scripts/cram tests || die "Tests fail with ${EPYTHON}"
}
