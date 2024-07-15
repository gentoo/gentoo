# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We are opam
OPAM_INSTALLER_DEP=" "
inherit opam

DESCRIPTION="Core libraries for opam"
HOMEPAGE="https://opam.ocaml.org/ https://github.com/ocaml/opam"
SRC_URI="https://github.com/ocaml/opam/archive/${PV/_/-}.tar.gz -> opam-${PV}.tar.gz"
S="${WORKDIR}/opam-${PV}"
OPAM_INSTALLER="${S}/opam-installer"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-ml/ocamlgraph:=
	dev-ml/re:=
	dev-ml/opam-file-format:=
	dev-ml/cmdliner:=
"
DEPEND="${RDEPEND}
	dev-ml/cppo"

src_prepare() {
	default
	cat <<- EOF >> "${S}/dune"
		(env
		 (dev
		  (flags (:standard -warn-error -3-9)))
		 (release
		  (flags (:standard -warn-error -3-9))))
	EOF

	# HACK: Probably bug in Makefile? Magic. See: https://bugs.gentoo.org/933845
	touch opam-installer.install || die
}

src_compile() {
	emake -j1 opam-installer
	emake -j1 ${PN}.install
}
