# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune multiprocessing

DESCRIPTION="Minimal HTTP server with a small request router"
HOMEPAGE="
	https://github.com/c-cube/tiny_httpd
	https://opam.ocaml.org/packages/tiny_httpd
"
SRC_URI="https://github.com/c-cube/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="camlzip ocamlopt test"

RDEPEND="
	>=dev-lang/ocaml-4.08
	dev-ml/result:=
	camlzip? ( >=dev-ml/camlzip-1.06:= )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-ml/qtest
		dev-ml/ounit2
		dev-ml/ptime
		dev-ml/qcheck
		net-misc/curl
	)
"

RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( camlzip )"

PATCHES=( "${FILESDIR}"/${P}-noseq.patch )

src_compile() {
	local pkgs="tiny_httpd"
	use camlzip && pkgs="${pkgs},tiny_httpd_camlzip"
	dune build -p "${pkgs}" -j $(makeopts_jobs) || die
}

src_install() {
	dune_src_install tiny_httpd
	use camlzip && dune_src_install "tiny_httpd_camlzip"
}
