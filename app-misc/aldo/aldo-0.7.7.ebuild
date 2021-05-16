# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A morse tutor"
HOMEPAGE="https://www.nongnu.org/aldo/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=media-libs/libao-0.8.5"
DEPEND="${RDEPEND}"

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}
