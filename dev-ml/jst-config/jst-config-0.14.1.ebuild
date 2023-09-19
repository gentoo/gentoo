# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Compile-time configuration for Jane Street libraries"
HOMEPAGE="https://github.com/janestreet/jst-config"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	=dev-ml/base-0.14*:=
	dev-ml/ppx_assert:=
	dev-ml/stdio:=
	dev-ml/dune-configurator:=
"
RDEPEND="${DEPEND}"
