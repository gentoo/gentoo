# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="ANOVA Extensions to the GNU Scientific Library"
HOMEPAGE="https://tracker.debian.org/pkg/tamuanova"
SRC_URI="http://cdn-fastly.deb.debian.org/debian/pool/main/t/tamuanova/tamuanova_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"

RDEPEND="sci-libs/gsl:0="
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo"

S="${WORKDIR}"/${PN}-0.2

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${P}-texinfo5.1.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
