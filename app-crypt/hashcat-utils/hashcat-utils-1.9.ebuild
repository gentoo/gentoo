# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a set of small utilities that are useful in advanced password cracking"
HOMEPAGE="https://github.com/hashcat/hashcat-utils"
SRC_URI="https://github.com/hashcat/hashcat-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${P}/src"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	for i in *.bin; do
		newbin ${i} ${i/.bin}
	done
}
