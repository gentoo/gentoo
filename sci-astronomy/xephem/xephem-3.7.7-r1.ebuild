# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Interactive tool for astronomical ephemeris and sky simulation"
HOMEPAGE="https://www.clearskyinstitute.com/xephem"
SRC_URI="https://www.clearskyinstitute.com/xephem/${P}.tgz"

LICENSE="XEphem"
SLOT=0
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=x11-libs/motif-2.3:0
	virtual/jpeg:0
	media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/groff"

HTML_DOCS=( GUI/xephem/help/. )
DOCS=( README )

PATCHES=(
	"${FILESDIR}/${P}-respect_env_vars.patch"
	"${FILESDIR}/${P}-implicits.patch"
	"${FILESDIR}/${P}-no_xprint.patch"
)

src_compile() {
	tc-export CC AR RANLIB
	emake -C GUI/xephem
}

src_install() {
	insinto /usr/share/X11/app-defaults
	newins - XEphem <<-EOF
		XEphem.ShareDir: /usr/share/${PN}
	EOF
	newenvd - 99xephem <<-EOF
		XEHELPURL=/usr/share/doc/${PF}/html/xephem.html
	EOF
	einstalldocs

	cd GUI/xephem || die
	dobin xephem
	doman xephem.1
	newicon XEphem.png ${PN}.png
	insinto /usr/share/${PN}
	doins -r auxil catalogs fifos fits gallery lo
	make_desktop_entry xephem XEphem ${PN}
}
