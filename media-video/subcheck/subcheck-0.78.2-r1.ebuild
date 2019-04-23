# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Subcheck checks srt subtitle files for errors"
HOMEPAGE="http://subcheck.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!sci-biology/ncbi-tools++"  # bug 377093
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i -e "s:${PN}.pl:${PN}:g" all-checksub || die "sed failed"
}

src_install() {
	gunzip man/subcheck.8.gz || die
	doman man/subcheck.8
	newbin subcheck.pl subcheck
	dobin all-checksub
	dodoc Changes
}
