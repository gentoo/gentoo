# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python subprocess interface"
HOMEPAGE="https://github.com/amoffat/sh"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}/sh-1.12.14-skip-unreliable-test.patch"
	"${FILESDIR}/sh-1.14.0-skip-unreliable-test.patch"
	# https://github.com/amoffat/sh/pull/540
	"${FILESDIR}/sh-1.14.0-fix-sleep-test.patch"
)

python_test() {
	"${EPYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
