# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="A deriving library for Ocsigen"
HOMEPAGE="https://github.com/ocsigen/deriving"
SRC_URI="https://github.com/ocsigen/deriving/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-ml/type-conv-108:=
	dev-ml/optcomp:=
	dev-ml/findlib:=
	dev-ml/camlp4:=
"
DEPEND="${RDEPEND}
	dev-ml/oasis"

DOCS=( CHANGES README.md )
oasis_configure_opts="--enable-tc"
OASIS_SETUP_COMMAND="./setup.exe"

src_configure() {
	emake setup.exe
	oasis_src_configure
}
