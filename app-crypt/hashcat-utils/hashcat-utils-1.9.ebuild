# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a set of small utilities that are useful in advanced password cracking"
HOMEPAGE="https://github.com/hashcat/hashcat-utils"
SRC_URI="https://github.com/hashcat/hashcat-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/src"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# File collision https://bugs.gentoo.org/667090
RDEPEND="!app-text/expander"

src_install() {
	for i in *.bin; do
		newbin ${i} ${i/.bin}
	done
}
