# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="An Async-pipe-based interface with OpenSSL."
HOMEPAGE="https://github.com/janestreet/async_ssl"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-lang/ocaml:=
	dev-ml/async:=
	dev-ml/base:=
	dev-ml/core:=
	dev-ml/dune-configurator:=
	dev-ml/ppx_jane:=
	dev-ml/stdio:=
	dev-ml/ocaml-ctypes:=
	dev-libs/openssl:0=
"
DEPEND="${RDEPEND}"
