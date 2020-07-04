# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="GKrellm2 plugin to take screen shots and lock screen"
HOMEPAGE="http://gkrellshoot.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellshoot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE=""

DEPEND="app-admin/gkrellm:2[X]"
RDEPEND="
	${DEPEND}
	virtual/imagemagick-tools"

S=${WORKDIR}/${P/s/S}
