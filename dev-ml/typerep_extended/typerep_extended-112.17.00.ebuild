# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/typerep_extended/typerep_extended-112.17.00.ebuild,v 1.1 2015/02/20 15:18:35 aballier Exp $

EAPI="5"

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Runtime types for OCaml (Extended)"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ml/typerep-112.17.00:=
	dev-ml/sexplib:=
	dev-ml/bin-prot:=
	dev-ml/core_kernel:=
	dev-ml/camlp4:="

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
DOCS=( "CHANGES.md" )
