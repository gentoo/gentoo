# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/type-conv/type-conv-112.01.01.ebuild,v 1.1 2015/03/18 17:21:02 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Mini library required for some other preprocessing libraries"
HOMEPAGE="http://janestreet.github.io/"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}.00/individual/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/ocaml-4.02[ocamlopt?]
	dev-ml/camlp4:="
DEPEND="${RDEPEND}
	>=dev-ml/findlib-1.3.2"

DOCS=( "README.md" "CHANGES.md" )

S="${WORKDIR}/${MY_P}"
