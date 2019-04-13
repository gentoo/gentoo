# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A special version of RepBase used by RepeatMasker"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="repeatmaskerlibraries-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Libraries"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please register and download repeatmaskerlibraries-${PV}.tar.gz"
	einfo 'at http://www.girinst.org/'
	einfo '(select the "Repbase Update - RepeatMasker edition" link)'
	einfo 'and place it into your DISTDIR directory.'
}

src_install() {
	insinto /usr/share/repeatmasker/Libraries
	doins "${S}"/RepeatMaskerLib.embl
	dodoc README
	dohtml README.html
}
