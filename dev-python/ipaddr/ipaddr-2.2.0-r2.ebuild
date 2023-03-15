# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python IP address manipulation library"
HOMEPAGE="https://github.com/google/ipaddr-py https://pypi.org/project/ipaddr/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 x86"

python_configure_all() {
	"${EPYTHON}" -m lib2to3 -n -w --no-diffs *.py || die
}

python_test() {
	"${EPYTHON}" ipaddr_test.py || die "Tests fail with ${EPYTHON}"
}
