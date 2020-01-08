# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="groovy little assembler"
HOMEPAGE="https://www.nasm.us/"
SRC_URI="https://www.nasm.us/pub/nasm/releasebuilds/${PV/_}/${P/_}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ia64 ~ppc64 x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

RDEPEND=""
DEPEND=""
# [fonts note] doc/psfonts.ph defines ordered list of font preference.
# Currently 'media-fonts/source-pro' is most preferred and is able to
# satisfy all 6 font flavours: tilt, chapter, head, etc.
BDEPEND="
	dev-lang/perl
	doc? (
		app-text/ghostscript-gpl
		dev-perl/Font-TTF
		dev-perl/Sort-Versions
		media-fonts/source-pro
		virtual/perl-File-Spec
	)
"

S=${WORKDIR}/${P/_}

PATCHES=(
	"${FILESDIR}"/${PN}-2.13.03-bsd-cp-doc.patch
)

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
