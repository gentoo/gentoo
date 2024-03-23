# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit texlive-common

DESCRIPTION="HeVeA is a quite complete and fast LaTeX to HTML translator"
HOMEPAGE="https://hevea.inria.fr/"
SRC_URI="https://hevea.inria.fr/distri/${P}.tar.gz"

LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

# - hevea's imagen script calls gs from app-text/ghostscript-gpl, hence
#   the RDEPEND (https://bugs.gentoo.org/927003).
DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt=]"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
	dev-texlive/texlive-latexextra
"
BDEPEND="dev-ml/ocamlbuild"

# bug #734350
QA_FLAGS_IGNORED=(
	/usr/bin/bibhva
	/usr/bin/hevea
	/usr/bin/esponja
	/usr/bin/hacha
)

src_compile() {
	rm -f config.sh || die

	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)/hevea" LATEXLIBDIR="/usr/share/texmf-site/tex/latex/hevea" config.sh

	if use ocamlopt; then
		emake PREFIX=/usr
	else
		emake PREFIX=/usr TARGET=byte
	fi
}

src_install() {
	if use ocamlopt; then
		emake DESTDIR="${ED}" PREFIX=/usr install
	else
		emake DESTDIR="${ED}" PREFIX=/usr TARGET=byte install
	fi

	dodoc README CHANGES
}

# If texmf-update is present this means we have a latex install; update it so
# that hevea.sty can be found
# Do not (r)depend on latex though because hevea does not need it itself
# If latex is installed later, it will see hevea.sty

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
