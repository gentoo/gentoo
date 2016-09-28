# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1
OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Simple, efficient iterators for OCaml"
HOMEPAGE="https://github.com/c-cube/gen"
SRC_URI="https://github.com/c-cube/gen/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit dev-ml/iTeML )
"
DOCS=( "README.md" "CHANGELOG.md" )
