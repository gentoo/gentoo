# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# We are opam
OPAM_INSTALLER_DEP=" "
OPAM_SKIP_VALIDATION=yes
inherit opam

DESCRIPTION="Core installer for opam packages"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/releases/download/${PV}/opam-full-${PV}.tar.gz"
S="${WORKDIR}/opam-full-${PV/_/-}"
OPAM_INSTALLER="${S}/opam-installer"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~x86"

RDEPEND="
	>=dev-lang/ocaml-4.02.3
	dev-ml/cmdliner:=
	~dev-ml/opam-format-${PV}
"
DEPEND="${RDEPEND}
	dev-ml/findlib"

src_configure() {
	econf \
		--prefix="${EPREFIX}/usr" \
		--with-mccs \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--mandir="${EPREFIX}/usr/share/man"
}

src_compile() {
	sed -e 's/DUNE = .*$/DUNE = /' -i Makefile.config
	emake lib-ext
	#passing -jX to the dune build leads to errors
	#see: https://github.com/ocaml/opam/issues/3585
	emake DUNE_PROMOTE_ARG="" -j1
}
