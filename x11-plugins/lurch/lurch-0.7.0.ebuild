# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="OMEMO encryption for libpurple (XEP-0384)"
HOMEPAGE="https://github.com/gkdr/lurch"
SRC_URI="https://github.com/gkdr/lurch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"  # likely not GPL-3+, https://github.com/gkdr/lurch/issues/165
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

# NOTE: Some of these dependencies seem like leftovers in the build system
#       and can probably be dropped with lurch >=0.7.1
#       (https://github.com/gkdr/lurch/issues/164)
RDEPEND="
	dev-db/sqlite
	dev-libs/glib
	dev-libs/libgcrypt:=
	dev-libs/libxml2
	dev-libs/mxml
	net-im/pidgin:=
	net-libs/libaxc
	net-libs/libomemo
	>=net-libs/libsignal-protocol-c-2.3.2
	"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cmocka )
	"

RESTRICT="!test? ( test )"

src_prepare() {
	rm -Rv lib/{axc,libomemo} || die  # unbundle
	default
}

src_compile() {
	local makeargs=(
		CC="$(tc-getCC)"
		LIBGCRYPT_CONFIG="$(tc-getPROG LIBGCRYPT_CONFIG libgcrypt-config)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		XML2_CONFIG="$(tc-getPROG XML2_CONFIG xml2-config)"
	)
	emake "${makeargs[@]}"
}
