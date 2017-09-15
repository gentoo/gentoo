# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit opam

DESCRIPTION="Jane Street's alternative to the standard library"
HOMEPAGE="https://github.com/janestreet/core"
SRC_URI="https://github.com/janestreet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

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
DEPEND="${RDEPEND} dev-ml/jbuilder"
PATCHES=( "${FILESDIR}/glibc225.patch" )
