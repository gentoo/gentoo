# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/macaque/macaque-0.7.1.ebuild,v 1.1 2014/10/30 08:11:53 aballier Exp $

EAPI=5

inherit oasis

DESCRIPTION="DSL for SQL Queries in Caml"
HOMEPAGE="http://ocsigen.org/macaque/"
SRC_URI="https://github.com/ocsigen/macaque/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/pgocaml-2.1:=
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )"
RDEPEND="${DEPEND}"
DOCS=( Changelog README.md )
