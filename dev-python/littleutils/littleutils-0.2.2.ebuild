# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Small personal collection of Python utility functions"
HOMEPAGE="https://github.com/alexmojaki/littleutils"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

python_test() {
	"${EPYTHON}" -m doctest -v ${PN}/__init__.py || die "Tests fail with ${EPYTHON}"
}
