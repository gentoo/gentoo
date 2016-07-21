# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis

DESCRIPTION="DSL for SQL Queries in Caml"
HOMEPAGE="http://ocsigen.org/macaque/"
SRC_URI="https://github.com/ocsigen/macaque/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-ml/pgocaml-2.1:=
	dev-ml/camlp4:="
DEPEND="${RDEPEND}
	dev-ml/oasis"
DOCS=( Changelog README.md )
OASIS_SETUP_COMMAND="./setup.exe"

src_configure() {
	emake setup.exe
	oasis_src_configure
}
