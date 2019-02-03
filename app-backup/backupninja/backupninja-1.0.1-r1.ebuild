# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

# This thing change with every release, how idiotic...
NODE_NUMBER=275

DESCRIPTION="lightweight, extensible meta-backup system"
HOMEPAGE="http://riseuplabs.org/backupninja/"
SRC_URI="https://labs.riseup.net/code/attachments/download/${NODE_NUMBER}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-util/dialog"
DEPEND=""

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_configure() {
	econf --localstatedir=/var #578614
}
