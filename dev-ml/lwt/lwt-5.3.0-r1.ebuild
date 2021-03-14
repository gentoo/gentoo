# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="Cooperative light-weight thread library for OCaml"
SRC_URI="https://github.com/ocsigen/lwt/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt"

DEPEND="
	dev-ml/seq:=
	dev-ml/result:=
	dev-ml/mmap:=
	dev-ml/ocplib-endian:=
	>=dev-ml/ppxlib-0.18.0:=
	dev-ml/react:=
	dev-ml/dune-configurator:=
	dev-libs/libev"
RDEPEND="${DEPEND}
	!<www-servers/ocsigen-1.1"
BDEPEND="
	>=dev-ml/cppo-1.6.6
	dev-ml/findlib"

# backported from https://github.com/ocsigen/lwt/pull/807
PATCHES=(
	"${FILESDIR}"/${PN}-5.3.0-ppxlib-0.18.0.patch
)
