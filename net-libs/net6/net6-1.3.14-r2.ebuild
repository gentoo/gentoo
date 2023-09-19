# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Network access framework for IPv4/IPv6 written in C++"
HOMEPAGE="https://gobby.github.io/"
SRC_URI="https://github.com/gobby/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="nls"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="
	dev-libs/libsigc++:2
	>=net-libs/gnutls-1.2.10:=
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}/${P}-gnutls-3.4.patch"
)

src_configure() {
	append-cxxflags -std=c++11

	econf \
		--disable-static \
		$(use_enable nls)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
