# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools verify-sig

DESCRIPTION="Create debuginfo and source file distributions"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz.sig
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/elfutils-0.176-r1
"
DEPEND=${RDEPEND}
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
	verify-sig? (
		app-crypt/openpgp-keys-debugedit
	)
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/debugedit.gpg

PATCHES=(
	"${FILESDIR}"/${P}-readelf.patch
	"${FILESDIR}"/${P}-zero-dir-entry.patch
)

src_prepare() {
	default
	eautoreconf
}
