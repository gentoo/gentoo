# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils

DESCRIPTION="ANOVA Extensions to the GNU Scientific Library"
HOMEPAGE="https://tracker.debian.org/pkg/tamuanova"
SRC_URI="http://cdn-fastly.deb.debian.org/debian/pool/main/t/tamuanova/tamuanova_${PV}.orig.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="sci-libs/gsl"
DEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

S="${WORKDIR}"/${PN}-0.2

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${P}-texinfo5.1.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_configure(){
	econf --disable-static
}

src_install(){
	emake DESTDIR="${D}" install
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
