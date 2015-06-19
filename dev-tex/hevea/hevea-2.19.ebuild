# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/hevea/hevea-2.19.ebuild,v 1.1 2014/11/19 09:24:59 aballier Exp $

EAPI=5

inherit eutils multilib

IUSE="+ocamlopt"

DESCRIPTION="HeVeA is a quite complete and fast LaTeX to HTML translator"
HOMEPAGE="http://hevea.inria.fr/"
SRC_URI="http://hevea.inria.fr/distri/${P}.tar.gz"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]"
RDEPEND="${DEPEND}
	dev-texlive/texlive-latexextra"

src_compile() {
	rm -f config.sh
	emake PREFIX=/usr DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)/hevea" LATEXLIBDIR="/usr/share/texmf-site/tex/latex/hevea" config.sh || die "Failed to create config.sh"
	if use ocamlopt; then
		emake PREFIX=/usr || die "Failed to build native code binaries"
	else
		emake PREFIX=/usr TARGET=byte || die "Failed to build bytecode binaries"
	fi
}

src_install() {
	if use ocamlopt; then
		emake DESTDIR="${D}" PREFIX=/usr install || die "Install failed"
	else
		emake DESTDIR="${D}" PREFIX=/usr TARGET=byte install || die "Install failed"
	fi

	dodoc README CHANGES
}

# If texmf-update is present this means we have a latex install; update it so
# that hevea.sty can be found
# Do not (r)depend on latex though because hevea does not need it itself
# If latex is installed later, it will see hevea.sty

pkg_postinst() {
	if [ "$ROOT" = "/" ] && [ -x /usr/sbin/texmf-update ] ; then
		/usr/sbin/texmf-update
	fi
}

pkg_postrm() {
	if [ "$ROOT" = "/" ] && [ -x /usr/sbin/texmf-update ] ; then
		/usr/sbin/texmf-update
	fi
}
