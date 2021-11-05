# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library for building WebSocket servers and clients in Python"
HOMEPAGE="https://websockets.readthedocs.io/"
SRC_URI="
	https://github.com/aaugustin/${PN}/archive/${PV}.tar.gz -> ${P}-src.tar.gz
	https://dev.gentoo.org/~sbraz/${P}-python-3.10-support.patch.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"

distutils_enable_tests unittest

PATCHES=(
	# https://github.com/aaugustin/websockets/commit/08d8011132ba038b3f6c4d591189b57af4c9f147
	"${WORKDIR}/${P}-python-3.10-support.patch"
)

src_prepare() {
	# these fail due to timeouts on slower hardware
	sed -e 's:test_keepalive_ping_with_no_ping_timeout:_&:' \
		-e 's:test_keepalive_ping(:_&:' \
		-i tests/legacy/test_protocol.py || die

	distutils-r1_src_prepare
}

# Be more tolerant with time-sensitive tests for slow systems.
export WEBSOCKETS_TESTS_TIMEOUT_FACTOR=100
