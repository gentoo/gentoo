# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Subcheck checks srt subtitle files for errors"
HOMEPAGE="http://subcheck.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!sci-biology/ncbi-tools++"  # bug 377093
RDEPEND="${DEPEND}"

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
