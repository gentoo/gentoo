# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# We are opam
OPAM_INSTALLER_DEP=" "
OPAM_SKIP_VALIDATION=yes
inherit dune

DESCRIPTION="Core installer for opam packages"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/releases/download/${PV}/opam-full-${PV}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/dev-ml/opam/opam-2.1.0-dose3-6.patch.xz"
S="${WORKDIR}/opam-full-${PV/_/-}"
OPAM_INSTALLER="${S}/_build/install/default/bin/opam-installer"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

PATCHES=( "${WORKDIR}"/opam-2.1.0-dose3-6.patch )

RDEPEND="
	>=dev-lang/ocaml-4.02.3:=
	dev-ml/cmdliner:=
	~dev-ml/opam-format-${PV}:=
	>=dev-ml/dose3-6:=
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
