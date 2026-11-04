# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Maintain remote web sites with ease"
HOMEPAGE="https://notroj.github.io/sitecopy/"
SRC_URI="https://notroj.github.io/sitecopy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="expat nls rsh ssl webdav xml zlib"
# The tests are all pytest->container based
RESTRICT="test"

RDEPEND="
	>=net-libs/neon-0.29[expat?,ssl?,zlib?]
	rsh? ( net-misc/netkit-rsh )
	nls? ( virtual/libintl )
	xml? ( >=net-libs/neon-0.24.6:=[-expat] )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	local myconf=(
		$(use_enable nls)
		$(use_enable rsh)
		$(use_enable webdav)
		$(use_with expat)
		$(use_with ssl ssl openssl)
		$(use_with xml libxml2)
		--with-neon
		--without-included-neon
	)

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}"/usr/share/doc/${PF} install
}
