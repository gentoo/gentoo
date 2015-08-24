# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis

DESCRIPTION="an implementation of the Light Weight Directory Access Protocol"
HOMEPAGE="http://git-jpdeplaix.dyndns.org/libs/ocamldap.git/"
SRC_URI="https://bitbucket.org/deplai_j/${PN}/downloads/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-ml/pcre-ocaml:=
	dev-ml/ocaml-ssl:=
	dev-ml/ocamlnet:="
RDEPEND="${DEPEND}"

DOCS=( AUTHORS.txt Changelog INSTALL.txt README.txt )

PATCHES=( "${FILESDIR}/ocaml-4.02.patch" )

src_install() {
	oasis_src_install
	use doc && dohtml -r doc/ocamldap/html
}
