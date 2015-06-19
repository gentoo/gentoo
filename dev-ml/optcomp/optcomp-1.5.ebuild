# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/optcomp/optcomp-1.5.ebuild,v 1.2 2014/03/14 07:45:31 jlec Exp $

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Optional compilation for OCaml with cpp-like directives"
HOMEPAGE="http://github.com/diml/optcomp"
SRC_URI="http://github.com/diml/optcomp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( CHANGES.md README.md )
