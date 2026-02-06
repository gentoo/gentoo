# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PN="kasumi-unicode"
DESCRIPTION="Anthy-unicode dictionary maintenance tool"
HOMEPAGE="https://github.com/fujiwarat/kasumi-unicode/"
HASH_COMMIT="ef99504b3ff35b069a16cf5dbed29199f3301039"
SRC_URI="https://github.com/fujiwarat/kasumi-unicode/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${HASH_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~riscv ~sparc ~x86"
IUSE="nls"

RDEPEND="
	app-i18n/anthy-unicode
	dev-libs/glib:2
	virtual/libiconv
	x11-libs/gtk+:3
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=gnu++14
	econf ENABLE_NLS=$(usex nls 0 1)
}
