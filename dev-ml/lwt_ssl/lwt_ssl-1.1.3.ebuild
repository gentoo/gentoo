# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="GLib integration for Lwt"
SRC_URI="https://github.com/ocsigen/lwt_ssl/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt_ssl"

IUSE="+ocamlopt"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~arm ~ppc"

RDEPEND="
	dev-ml/base
	>=dev-ml/lwt-3.1:=
	>=dev-ml/ocaml-ssl-0.4.0:=
"
