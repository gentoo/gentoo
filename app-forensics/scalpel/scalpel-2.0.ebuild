# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A high performance file carver"
HOMEPAGE="https://github.com/sleuthkit/scalpel"
SRC_URI="http://www.digitalforensicssolutions.com/Scalpel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/tre"
DEPEND="${RDEPEND}"

DOCS=( Changelog README )

src_prepare() {
	# Set the default config file location
	sed -i -e "s:scalpel.conf:/etc/\0:" src/scalpel.h || die "sed failed"
	default
}

src_install() {
	default

	insinto /etc
	doins scalpel.conf
}
