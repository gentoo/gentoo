# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv sparc x86"

RDEPEND="dev-libs/libgcrypt:0
	net-im/pidgin[gtk]
	>=net-libs/libotr-4.0.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
