# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Reports the current time"
HOMEPAGE="https://github.com/janestreet/time_now"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64"
IUSE="+ocamlopt"

# Jane Street Minor
JSM=$(ver_cut 1-2)

RDEPEND="
	>=dev-lang/ocaml-5
	=dev-ml/base-${JSM}*:=[ocamlopt?]
	=dev-ml/jane-street-headers-${JSM}*:=[ocamlopt?]
	=dev-ml/jst-config-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_base-${JSM}*:=[ocamlopt?]
	=dev-ml/ppx_optcomp-${JSM}*:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-ml/dune-3.11"
