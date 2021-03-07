# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

AXC_PV=0.3.3
LIBOMEMO_PV=0.7.0

DESCRIPTION="OMEMO encryption for libpurple (XEP-0384)"
HOMEPAGE="https://github.com/gkdr/lurch"
SRC_URI="https://github.com/gkdr/lurch/releases/download/v${PV}/lurch-${PV}-src.tar.gz -> ${P}.tar.gz
	https://github.com/gkdr/axc/archive/v${AXC_PV}.tar.gz -> axc-${AXC_PV}.tar.gz
	https://github.com/gkdr/libomemo/archive/v${LIBOMEMO_PV}.tar.gz -> libomemo-${LIBOMEMO_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

# NOTE
#   The build systems of axc (ex-libaxolotl)
#   at https://github.com/gkdr/axc and of libomemo
#   at https://github.com/gkdr/libomemo build static
#   libraries (*.a files) only, so it is not clear when or
#   how to best unbundle them into standalone packages.
#   Related yet-to-be-merged pull requests to build shared libraries
#   exist upstream:
#   - https://github.com/gkdr/axc/pull/17
#   - https://github.com/gkdr/lurch/pull/151
#   - https://github.com/gkdr/libomemo/pull/30
RDEPEND="
	dev-db/sqlite
	dev-libs/glib
	dev-libs/libgcrypt:=
	dev-libs/libxml2
	dev-libs/mxml
	net-im/pidgin:=
	>=net-libs/libsignal-protocol-c-2.3.2
	"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	"

PATCHES=(
	# Unbundle net-libs/libsignal-protocol-c
	"${FILESDIR}"/${P}-libsignal-protocol-c.patch
	"${FILESDIR}"/${P}-axc-${AXC_PV}-libsignal-protocol-c.patch
)

src_prepare() {
	# Upgrade outdated bundle of axc
	rm -R lib/axc || die
	mv "${WORKDIR}"/axc-${AXC_PV} lib/axc || die

	# Upgrade outdated bundle of libomemo
	rm -R lib/libomemo || die
	mv "${WORKDIR}"/libomemo-${LIBOMEMO_PV} lib/libomemo || die

	# Unbundle axc's bundled net-libs/libsignal-protocol-c
	rm -R lib/axc/lib/libsignal-protocol-c || die

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
