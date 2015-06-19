# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-ipaddr/ocaml-ipaddr-2.5.0.ebuild,v 1.1 2014/12/01 09:59:25 aballier Exp $

EAPI=5

OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="OCaml library for manipulation of IP (and MAC) address representations"
HOMEPAGE="https://github.com/mirage/ocaml-ipaddr"
SRC_URI="https://github.com/mirage/ocaml-ipaddr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/sexplib:="
RDEPEND="${DEPEND}"

DOCS=( CHANGES README.md )
