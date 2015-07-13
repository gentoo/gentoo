# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/async_rpc_kernel/async_rpc_kernel-112.35.00.ebuild,v 1.1 2015/07/13 18:24:58 aballier Exp $

EAPI="5"

inherit oasis

DESCRIPTION="Platform-independent core of Async RPC library"
HOMEPAGE="http://bitbucket.org/yminsky/ocaml-core/wiki/Home"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/camlp4:=
	dev-ml/async_kernel:=
	dev-ml/bin-prot:=
	dev-ml/comparelib:=
	dev-ml/core_kernel:=
	dev-ml/custom_printf:=
	dev-ml/fieldslib:=
	dev-ml/pa_ounit:=
	dev-ml/sexplib:="
RDEPEND="${DEPEND}"

DOCS=( "CHANGES.md" )
