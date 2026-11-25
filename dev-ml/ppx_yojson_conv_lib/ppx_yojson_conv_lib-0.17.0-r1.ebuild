# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Runtime lib for ppx_yojson_conv"
HOMEPAGE="https://github.com/janestreet/ppx_yojson_conv_lib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/janestreet/${PN}"
else
	SRC_URI="https://github.com/janestreet/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-5.1.0
	>=dev-ml/yojson-1.7.0:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-ml/dune-3.11.0
"
