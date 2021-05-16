# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Automated de novo identification of repeat families from genomic sequences"
HOMEPAGE="http://www.repeatmasker.org/RepeatModeler.html"
SRC_URI="http://www.repeatmasker.org/${P^^}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

S=${WORKDIR}/${P^^}

PATCHES=(
	"${FILESDIR}"/${PN}-1.08-buffer-overflow.patch
	"${FILESDIR}"/${PN}-1.08-perl-shebangs.patch
)

src_prepare() {
	default
	sed -i "s|$path = \"\";|$path = \"${EPREFIX}/usr/libexec/${PN}\";|" scripts/recon.pl || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" -C src
}

src_install() {
	dobin scripts/*

	exeinto /usr/libexec/${PN}
	doexe src/{edgeredef,eledef,eleredef,famdef,imagespread}

	newdoc {00,}README

	if use examples; then
		insinto /usr/share/${PN}
		doins -r Demos
	fi
}
