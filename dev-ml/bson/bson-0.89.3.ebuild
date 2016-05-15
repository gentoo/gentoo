# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis

DESCRIPTION="An ocaml implementation for bson"
HOMEPAGE="http://massd.github.io/"
SRC_URI="https://github.com/MassD/bson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/camlp4:="
RDEPEND="${DEPEND}"
