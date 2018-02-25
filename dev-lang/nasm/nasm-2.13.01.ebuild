# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="groovy little assembler"
HOMEPAGE="http://www.nasm.us/"
SRC_URI="http://www.nasm.us/pub/nasm/releasebuilds/${PV/_}/${P/_}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~x64-cygwin ~amd64-fbsd ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

DEPEND="
	dev-lang/perl
	doc? (
		app-text/ghostscript-gpl
		dev-perl/Font-TTF
		dev-perl/Sort-Versions
		media-fonts/clearsans
		virtual/perl-File-Spec
	)
"

S=${WORKDIR}/${P/_}
PATCHES=( "${FILESDIR}"/${PN}-2.13.01-fix-docdir.patch )

src_configure() {
	strip-flags
	default
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default
	emake DESTDIR="${D}" install_rdf $(usex doc install_doc '')
}
