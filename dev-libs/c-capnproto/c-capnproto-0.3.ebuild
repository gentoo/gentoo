# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="C library/compiler for the Cap'n Proto serialization/RPC protocol"
HOMEPAGE="https://github.com/opensourcerouting/c-capnproto"
SRC_URI="https://github.com/opensourcerouting/c-capnproto/releases/download/${P}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils
"
