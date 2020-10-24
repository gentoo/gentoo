# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

EGIT_COMMIT="7154bde469f9b4f3f54ef82a8fa41e1592bb5693"

DESCRIPTION="Fast OpenStreetMap data tools"
HOMEPAGE="https://github.com/ramunasd/osmctools"
SRC_URI="https://github.com/ramunasd/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}
