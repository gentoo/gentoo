# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

DESCRIPTION="Generate Encapsulated Postscript Format files from one-page Postscript documents"
HOMEPAGE="https://telematics.tm.kit.edu/staff_bless.php?tab=%5B1512%5D#tabpanel-1512"
SRC_URI="https://tm.kit.edu/~bless/${P}.tar.gz"

S="${WORKDIR}/${PN}"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	app-text/ghostscript-gpl
"

src_configure() {
	tc-export CC
}

src_compile() {
	cd src/C || die
	emake bbox
}

src_install() {
	dobin src/C/bbox
	dobin bin/ps2eps

	doman doc/man/man1/bbox.1
	doman doc/man/man1/ps2eps.1

	local DOCS=( Changes.txt README.txt doc/pdf )
	local HTML_DOCS=( doc/html/. )
	einstalldocs
}
