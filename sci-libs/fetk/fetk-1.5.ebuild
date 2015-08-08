# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="The Finite Element ToolKit - Meta package"
HOMEPAGE="http://fetk.org/"
SRC_URI=""

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	~dev-libs/maloc-${PV}
	~media-libs/sg-${PV}
	~sci-libs/gamer-${PV}
	~sci-libs/mc-${PV}
	~sci-libs/punc-${PV}
	"
DEPEND=""
