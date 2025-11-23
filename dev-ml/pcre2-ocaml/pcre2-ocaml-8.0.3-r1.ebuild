# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DUNE_PKG_NAME=pcre2
inherit dune

DESCRIPTION="OCaml bindings to PCRE (Perl Compatibility Regular Expressions)"
HOMEPAGE="https://github.com/camlp5/pcre2-ocaml"
SRC_URI="https://github.com/camlp5/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libpcre2:=
	dev-ml/dune-configurator:=[ocamlopt?]
"
BDEPEND="test? ( dev-ml/ounit2 )"
