# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="https://websockets.readthedocs.io/"
SRC_URI="
	https://github.com/aaugustin/${PN}/archive/${PV}.tar.gz -> ${P}-src.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ppc64 ~riscv sparc x86"

distutils_enable_tests unittest

PATCHES=(
	# Fails checks for deprecations warnings on py3.9 for the loop argument
	"${FILESDIR}/${P}-py3.9-fix-deprecation.patch"
)

src_prepare() {
	# these fail due to timeouts on slower hardware
	sed -e 's:test_keepalive_ping_with_no_ping_timeout:_&:' \
		-e 's:test_keepalive_ping(:_&:' \
		-i tests/legacy/test_protocol.py || die
	distutils-r1_src_prepare
}
