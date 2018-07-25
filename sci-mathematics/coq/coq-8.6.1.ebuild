# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils multilib

MY_PV=${PV/_p/pl}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Proof assistant written in O'Caml"
HOMEPAGE="http://coq.inria.fr/"
SRC_URI="http://${PN}.inria.fr/distrib/V${MY_PV}/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk debug +ocamlopt doc camlp5"

RDEPEND="
	>=dev-lang/ocaml-3.11.2:=[ocamlopt?]
	camlp5? ( >=dev-ml/camlp5-6.02.3:=[ocamlopt?] )
	!camlp5? ( dev-ml/camlp4:= )
	gtk? ( >=dev-ml/lablgtk-2.10.1:=[sourceview,ocamlopt?] )"
DEPEND="${RDEPEND}
	dev-ml/findlib
	doc? (
		media-libs/netpbm[png,zlib]
		virtual/latex-base
		dev-tex/hevea
		dev-tex/xcolor
		dev-texlive/texlive-pictures
		dev-texlive/texlive-mathscience
		dev-texlive/texlive-latexextra
		)"

S=${WORKDIR}/${MY_P}

src_configure() {
	ocaml_lib=$(ocamlc -where)
	local myconf=(
		-prefix /usr
		-bindir /usr/bin
		-libdir /usr/$(get_libdir)/coq
		-mandir /usr/share/man
		-emacslib /usr/share/emacs/site-lisp
		-coqdocdir /usr/$(get_libdir)/coq/coqdoc
		-docdir /usr/share/doc/${PF}
		-configdir /etc/xdg/${PN}
		-lablgtkdir ${ocaml_lib}/lablgtk2
		)

	use debug && myconf+=( -debug )
	use doc || myconf+=( -with-doc no )

	if use gtk; then
		if use ocamlopt; then
			myconf+=( -coqide opt )
		else
			myconf+=( -coqide byte )
		fi
	else
		myconf+=( -coqide no )
	fi

	use ocamlopt || myconf+=( -byte-only )

	if use camlp5; then
		myconf+=( -usecamlp5 -camlp5dir ${ocaml_lib}/camlp5 )
	else
		myconf+=( -usecamlp4 )
	fi

	export CAML_LD_LIBRARY_PATH="${S}/kernel/byterun/"
	./configure ${myconf[@]} || die "configure failed"
}

src_compile() {
	emake STRIP="true" -j1 world VERBOSE=1
}

src_test() {
	emake STRIP="true" check VERBOSE=1
}

src_install() {
	emake STRIP="true" COQINSTALLPREFIX="${D}" install VERBOSE=1
	dodoc README.md CREDITS CHANGES

	use gtk && make_desktop_entry "coqide" "Coq IDE" "${EPREFIX}/usr/share/coq/coq.png"
}
