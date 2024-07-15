# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We are opam
OPAM_INSTALLER_DEP=" "
inherit dune

DESCRIPTION="Core libraries for opam"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV}"
OPAM_INSTALLER="${S}/opam-installer"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt test"
RESTRICT="test" #sandbox not working

RDEPEND="
	~dev-ml/opam-core-${PV}:=
	dev-ml/re:=[ocamlopt?]
	dev-ml/opam-file-format:=[ocamlopt?]
	dev-ml/dose3:=[ocamlopt?]
	dev-ml/mccs:=[ocamlopt?]
"
DEPEND="${RDEPEND}
	dev-ml/cppo"
BDEPEND="test? (
	sys-apps/bubblewrap
)"

src_prepare() {
	default
	cat <<- EOF >> "${S}/dune"
		(env
		 (dev
		  (flags (:standard -warn-error -3-9-33)))
		 (release
		  (flags (:standard -warn-error -3-9-33))))
	EOF
	sed -i \
		-e '/wrap-build-commands/d' \
		-e '/wrap-install-commands/d' \
		-e '/wrap-remove-commands/d' \
		tests/reftests/opamroot-versions.test \
		|| die
}

src_compile() {
	dune-compile ${PN}
}
