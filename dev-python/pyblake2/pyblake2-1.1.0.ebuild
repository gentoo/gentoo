# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
inherit distutils-r1

DESCRIPTION="BLAKE2 hash function extension module"
HOMEPAGE="https://github.com/dchest/pyblake2 https://pypi.python.org/pypi/pyblake2"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

# pyblake2 itself allows more licenses but blake2 allows the following three
LICENSE="|| ( CC0-1.0 openssl Apache-2.0 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

python_test() {
	"${EPYTHON}" test/test.py || die "Tests fail with ${EPYTHON}"
}
