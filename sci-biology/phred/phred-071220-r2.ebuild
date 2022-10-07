# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A base caller for Sanger DNA sequencing"
HOMEPAGE="http://phrap.org/phredphrapconsed.html"
SRC_URI="${PN}-dist-${PV}.b-acd.tar.gz"
S="${WORKDIR}"

LICENSE="phrap"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

PATCHES=(
	"${FILESDIR}"/${PN}-071220-fix-build-system.patch
	"${FILESDIR}"/${PN}-071220-fix-qa.patch
)

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "${SRC_URI}, then place it into your DISTDIR directory."
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin phred daev

	insinto /usr/share/phred
	doins phredpar.dat

	newenvd - 99phred <<- EOF
		PHRED_PARAMETER_FILE="${EPREFIX}/usr/share/phred/phredpar.dat"
	EOF

	newdoc DAEV.DOC DAEV.DOC.txt
	newdoc PHRED.DOC PHRED.DOC.txt
}
