# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

DESCRIPTION="PAM module for authenticating against PKCS#11 tokens"
HOMEPAGE="https://github.com/opensc/pam_p11/wiki"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="virtual/pam
		dev-libs/libp11
		dev-libs/openssl:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_configure() {
	econf --with-pamdir="$(getpam_mod_dir)"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
