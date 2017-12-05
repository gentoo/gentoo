# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gkrellm-plugin

S=${WORKDIR}/${P/s/S}
DESCRIPTION="GKrellm2 plugin to take screen shots and lock screen"
HOMEPAGE="http://gkrellshoot.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellshoot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	app-admin/gkrellm[X]
	virtual/imagemagick-tools
"
