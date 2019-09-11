# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="E"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="E is a theorem prover for full first-order logic with equality"
HOMEPAGE="https://wwwlehre.dhbw-stuttgart.de/~sschulz/E/E.html"
SRC_URI="http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${PV}/${MY_PN}.tgz -> ${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-texlive/texlive-latex )"

S="${WORKDIR}"/${MY_PN}

PATCHES=( "${FILESDIR}"/${PN}-2.3-build-system.patch )

src_prepare() {
	default
	rm -f DOC/eprover.pdf
}

src_configure() {
	./configure --prefix="${ED}/usr" \
		--man-prefix="${ED}/usr/share/man" \
		|| die "E configure failed"

	sed -e "s@CFLAGS     = @CFLAGS     = ${CFLAGS} @" \
		-e "s@LD         = \$(CC) @LD         = \$(CC) ${LDFLAGS} @" \
		-i "${S}/Makefile.vars" \
		|| die "Could not add our flags to Makefile.vars"
}

src_compile() {
	default
	use doc && emake documentation
}

src_install() {
	default

	local DOCS=(
		"README.md"
		"DOC/ANNOUNCE"
		"DOC/CONTRIBUTORS"
		"DOC/DONE"
		"DOC/E-REMARKS"
		"DOC/E-REMARKS.english"
		"DOC/E-USERS"
		"DOC/HISTORY"
		"DOC/NEWS"
		"DOC/PORTING"
		"DOC/ReadMe"
		"DOC/THINKME"
		"DOC/TODO"
		"DOC/TPTP_SUBMISSION"
		"DOC/WISHLIST"
		"DOC/eprover.pdf"
	)
	local HTML_DOCS=( "DOC" )
	einstalldocs

	if use examples; then
		insinto /usr/share/${MY_PN}/examples
		doins -r EXAMPLE_PROBLEMS
		doins -r SIMPLE_APPS
	fi
}
