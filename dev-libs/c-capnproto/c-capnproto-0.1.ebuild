# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-utils

DESCRIPTION="C library/compiler for the Cap'n Proto serialization/RPC protocol"
HOMEPAGE="https://github.com/opensourcerouting/c-capnproto"
SRC_URI="https://github.com/opensourcerouting/c-capnproto/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=""
DEPEND="${DEPEND}
	test? ( dev-cpp/gtest )"
S="${WORKDIR}/${PN}-${P}"
PATCHES=(
	"${FILESDIR}/gtest.patch"
)
