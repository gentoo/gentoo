# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A base caller for Sanger DNA sequencing"
HOMEPAGE="http://phrap.org/phredphrapconsed.html"
SRC_URI="phred-dist-071220.b-acd.tar.gz"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

RESTRICT="fetch"
PATCHES=(
	"${FILESDIR}/${PN}-071220-fix-build-system.patch"
	"${FILESDIR}/${PN}-071220-fix-qa.patch"
)

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "${SRC_URI}, then place it in ${DISTDIR}"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin phred daev

	insinto /usr/share/${PN}
	doins phredpar.dat

	echo "PHRED_PARAMETER_FILE=${EPREFIX}/usr/share/${PN}/phredpar.dat" > 99phred || die
	doenvd 99phred

	newdoc DAEV.DOC DAEV.DOC.txt
	newdoc PHRED.DOC PHRED.DOC.txt
}
