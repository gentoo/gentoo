# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-libs/libgcrypt:0
	net-im/pidgin[gtk]
	>=net-libs/libotr-4.0.0
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
# autoconf-archive for F_S patch
BDEPEND="
	dev-util/intltool
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.2-dont-clobber-fortify-source.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
