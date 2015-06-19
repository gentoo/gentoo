# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/async_extra/async_extra-112.24.00.ebuild,v 1.1 2015/03/18 17:26:46 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Jane Street Capital's asynchronous execution library (extra)"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P%.*}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.00.0:=
	>=dev-ml/sexplib-109.20.00:=
	>=dev-ml/fieldslib-109.20.00:=
	>=dev-ml/bin-prot-109.15.00:=
	>=dev-ml/pa_ounit-109.18.00:=
	>=dev-ml/pipebang-109.15.00:=
	>=dev-ml/core-${PV}:=
	>=dev-ml/async_kernel-${PV}:=
	>=dev-ml/async_unix-${PV}:=
	dev-ml/custom_printf:=
	dev-ml/herelib:=
	dev-ml/pa_test:=
	dev-ml/camlp4:=
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
