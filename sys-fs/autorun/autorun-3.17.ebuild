# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="auto cdrom mounter for the lazy user"
HOMEPAGE="http://autorun.sourceforge.net/"
SRC_URI="mirror://sourceforge/autorun/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	dev-util/intltool
	app-text/xmlto
	app-text/docbook-xml-dtd:4.1.2"

export KDEDIR=/usr

PATCHES=( "${FILESDIR}/${P}-headers.patch" )
