# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-multilib

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Protocol Buffers implementation in C"
HOMEPAGE="https://github.com/protobuf-c/protobuf-c/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc ~x86"
IUSE="static-libs test"

RDEPEND=">=dev-libs/protobuf-2.6.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( ${AUTOTOOLS_DEPEND} )
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if ! use test ; then
		epatch "${FILESDIR}"/${PN}-1.1.0-no-build-tests.patch
		AUTOTOOLS_AUTORECONF=true
	fi
	autotools-multilib_src_prepare
}
