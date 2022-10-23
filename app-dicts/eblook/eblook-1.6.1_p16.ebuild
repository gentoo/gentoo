# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Interactive search utility for electronic dictionaries"
HOMEPAGE="http://openlab.ring.gr.jp/edict/eblook/"
SRC_URI="http://openlab.ring.gr.jp/edict/eblook/dist/${PN}-$(ver_cut 1-3).tar.gz"
SRC_URI+=" mirror://debian/pool/main/e/eblook/eblook_$(ver_cut 1-3)-$(ver_cut 5).debian.tar.xz"
S="${WORKDIR}"/${PN}-$(ver_cut 1-3)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

DEPEND=">=dev-libs/eb-3.3.4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/debian/patches
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --with-eb-conf="${EPREFIX}"/etc/eb.conf
}
