# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-base64/ocaml-base64-2.0.0.ebuild,v 1.1 2015/07/27 07:49:45 aballier Exp $

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Library for radix-64 representation (de)coding"
HOMEPAGE="https://github.com/mirage/ocaml-base64"
SRC_URI="https://github.com/mirage/ocaml-base64/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/ocaml-4.02[ocamlopt?]"
DEPEND="${RDEPEND}
	>=dev-ml/findlib-1.3.2"

DOCS=( "README.md" "CHANGES.md" )
