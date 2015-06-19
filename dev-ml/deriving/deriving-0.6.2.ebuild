# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/deriving/deriving-0.6.2.ebuild,v 1.2 2014/10/23 10:51:37 aballier Exp $

EAPI=5

OASIS_BUILD_TESTS=1

inherit oasis

DESCRIPTION="A deriving library for Ocsigen"
HOMEPAGE="http://github.com/ocsigen/deriving"
SRC_URI="http://github.com/ocsigen/deriving/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-ml/type-conv-108:=
	dev-ml/optcomp:=
"
DEPEND="${RDEPEND}
	dev-ml/oasis"

DOCS=( CHANGES README.md )
oasis_configure_opts=( --enable-tc )
