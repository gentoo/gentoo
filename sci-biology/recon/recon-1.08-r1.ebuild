# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Automated de novo identification of repeat families from genomic sequences"
HOMEPAGE="http://www.repeatmasker.org/RepeatModeler.html"
SRC_URI="http://www.repeatmasker.org/${P^^}.tar.gz"
S="${WORKDIR}/${P^^}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-1.08-buffer-overflow.patch
	"${FILESDIR}"/${PN}-1.08-perl-shebangs.patch
	"${FILESDIR}"/${PN}-1.08-Wimplicit-function-declaration.patch
)

src_prepare() {
	default
	sed -i "s|$path = \"\";|$path = \"${EPREFIX}/usr/libexec/recon\";|" scripts/recon.pl || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" -C src
}

src_install() {
	dobin scripts/*

	exeinto /usr/libexec/recon
	doexe src/{edgeredef,eledef,eleredef,famdef,imagespread}

	newdoc {00,}README

	if use examples; then
		insinto /usr/share/recon
		doins -r Demos
	fi
}
