# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Pidgin GPG/OpenPGP (XEP-0027) plugin"
HOMEPAGE="https://github.com/Draghtnod/Pidgin-GPG"
SRC_URI="https://github.com/Draghtnod/Pidgin-GPG/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="app-crypt/gpgme:=
	net-im/pidgin"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/Pidgin-GPG-${PV}"

PATCHES=(
	"${FILESDIR}/pidgin-gpg-0.9.3_musl-support.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
