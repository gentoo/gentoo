# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="A command line utility to display the ink level of your printer"
SRC_URI="mirror://sourceforge/ink/${P/_}.tar.gz"
HOMEPAGE="http://ink.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">net-print/libinklevel-0.8"
RDEPEND="${DEPEND}"

src_configure() {
	# always use /bin/bash as configure shell, bug #526548
	CONFIG_SHELL=/bin/bash default
}
