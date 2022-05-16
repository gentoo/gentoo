# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Small personal collection of Python utility functions"
HOMEPAGE="https://github.com/alexmojaki/littleutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

python_test() {
	"${EPYTHON}" -m doctest -v ${PN}/__init__.py || die "Tests fail with ${EPYTHON}"
}
