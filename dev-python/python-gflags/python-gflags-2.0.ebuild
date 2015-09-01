# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Google's Python argument parsing library"
HOMEPAGE="https://github.com/gflags/python-gflags"
SRC_URI="https://python-gflags.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-scripts-install.patch
	"${FILESDIR}"/${P}-tests-respect-tmpdir.patch
	"${FILESDIR}"/${P}-skip-test-as-root.patch #475134
	"${FILESDIR}"/${P}-tests-python-2.7.patch #447482
)

python_test() {
	# https://code.google.com/p/python-gflags/issues/detail?id=15&thanks=15&ts=1372948007
	local t
	cd tests || die
	for t in *.py; do
		# (it's ok to run the gflags_googletest.py too)
		"${PYTHON}" "${t}" || die "Tests fail with ${EPYTHON}"
	done
}
