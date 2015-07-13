# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/incremental/incremental-112.35.00.ebuild,v 1.1 2015/07/13 18:34:05 aballier Exp $

EAPI="5"

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Library for incremental computations"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-ml/core:=
	dev-ml/fieldslib:=
	dev-ml/pa_ounit:=
	dev-ml/pa_test:=
	dev-ml/sexplib:=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
