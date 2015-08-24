# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit oasis

DESCRIPTION="Syntax extension that helps writing in-line test in ocaml"
HOMEPAGE="https://bitbucket.org/yminsky/ocaml-core/wiki/Home"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}/files/${P%.*}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/ounit-1.1.1:=
	dev-ml/camlp4:="
RDEPEND="${DEPEND}"

DOCS=( "readme.md" )
