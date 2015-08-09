# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1
inherit oasis

DESCRIPTION="Zed is an abstract engine for text edition"
HOMEPAGE="http://forge.ocamlcore.org/projects/zed/"
SRC_URI="http://forge.ocamlcore.org/frs/download.php/944/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-ml/camomile:=
	dev-ml/react:="
RDEPEND="${DEPEND}"
DOCS=( "CHANGES" )

src_prepare() {
	#bug 1105 upstream
	sed -i "s/<code>/< code >/" src/zed_edit.mli
}
