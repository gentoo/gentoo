# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HeVeA is a quite complete and fast LaTeX to HTML translator"
HOMEPAGE="http://hevea.inria.fr/"
SRC_URI="http://hevea.inria.fr/distri/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt=]"
RDEPEND="
	${DEPEND}
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

	emake PREFIX="${EPREFIX}"/usr DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)/hevea" LATEXLIBDIR="/usr/share/texmf-site/tex/latex/hevea" config.sh

	if use ocamlopt; then
		emake PREFIX="${EPREFIX}"/usr
	else
		emake PREFIX="${EPREFIX}"/usr TARGET=byte
	fi
}

src_install() {
	if use ocamlopt; then
		emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	else
		emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr TARGET=byte install
	fi

	dodoc README CHANGES
}

# If texmf-update is present this means we have a latex install; update it so
# that hevea.sty can be found
# Do not (r)depend on latex though because hevea does not need it itself
# If latex is installed later, it will see hevea.sty

pkg_postinst() {
	if [[ -z "${ROOT}" ]] && [[ -x "${EPREFIX}"/usr/sbin/texmf-update ]] ; then
		"${EPREFIX}"/usr/sbin/texmf-update
	fi
}

pkg_postrm() {
	if [[ -z "${ROOT}" ]] && [[ -x "${EPREFIX}"/usr/sbin/texmf-update ]] ; then
		"${EPREFIX}"/usr/sbin/texmf-update
	fi
}
