# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Finite Element ToolKit - Meta package"
HOMEPAGE="http://fetk.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	~dev-libs/maloc-${PV}
	~media-libs/sg-${PV}
	~sci-libs/gamer-${PV}
	~sci-libs/mc-${PV}
	~sci-libs/punc-${PV}
"
