# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Interactive search utility for electronic dictionaries"
HOMEPAGE="http://openlab.ring.gr.jp/edict/eblook/"
SRC_URI="http://openlab.ring.gr.jp/edict/eblook/dist/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

DEPEND=">=dev-libs/eb-3.3.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%_*}"

PATCHES=( "${FILESDIR}"/${P}-LDFLAGS.patch )

src_configure() {
	econf --with-eb-conf="${EPREFIX}"/etc/eb.conf
}
