# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# The fork at https://github.com/wez/atomicparsley uses unusual versioning, so
# we sadly need to hardcode the hash and update it per-release.
MY_COMMIT_HASH="e7ad03a"
MY_PV="$(ver_cut 5).$(ver_cut 7).${MY_COMMIT_HASH}"
inherit cmake flag-o-matic

DESCRIPTION="Command line program for manipulating iTunes-style metadata in MPEG4 files"
HOMEPAGE="https://github.com/wez/atomicparsley http://atomicparsley.sourceforge.net"
SRC_URI="https://github.com/wez/atomicparsley/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv ~sparc x86"

src_configure() {
	# APar_sha1.cpp:116:47 and 117:43: warning: dereferencing type-punned
	# pointer will break strict-aliasing rules
	append-flags -fno-strict-aliasing

	cmake_src_configure
}

src_test() {
	ln -s "${BUILD_DIR}"/AtomicParsley || die
	tests/test.sh || die
}
