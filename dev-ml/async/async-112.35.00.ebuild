# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/async/async-112.35.00.ebuild,v 1.1 2015/07/13 18:27:13 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1
OASIS_BUILD_TESTS=1

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Jane Street Capital's asynchronous execution library"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND=">=dev-lang/ocaml-4.00.0:=
	>=dev-ml/async_kernel-${PV}:=
	>=dev-ml/async_unix-${PV}:=
	>=dev-ml/async_extra-${PV}:=
	dev-ml/camlp4:=
	"
DEPEND="${RDEPEND}
	test? ( >=dev-ml/ounit-1.0.2 dev-ml/core_bench dev-ml/pa_ounit )"

S="${WORKDIR}/${MY_P}"

src_install() {
	oasis_src_install
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
