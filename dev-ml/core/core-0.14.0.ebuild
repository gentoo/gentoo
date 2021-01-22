# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="ocamlopt"

# TODO: Wants quickcheck_deprecated?
RESTRICT="test"

RDEPEND="
	dev-ml/base:=
	dev-ml/configurator:=
	dev-ml/core_kernel:=
	dev-ml/ppx_assert:=
	dev-ml/ppx_driver:=
	dev-ml/ppx_jane:=
	dev-ml/sexplib:=
	dev-ml/spawn:=
	dev-ml/stdio:=
	dev-ml/ocaml-migrate-parsetree:=
"
DEPEND="${RDEPEND}"
