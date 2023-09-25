# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Encryption and decryption"
HOMEPAGE="https://sourceforge.net/projects/ccrypt/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="emacs"

RDEPEND="virtual/libcrypt:="
DEPEND="
	${RDEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11-refresh-macro-clang16.patch
)

src_prepare() {
	default

	# Clang 16 patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable emacs)
}
