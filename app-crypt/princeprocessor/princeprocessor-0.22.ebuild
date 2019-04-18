# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Standalone password candidate generator using the PRINCE algorithm"
HOMEPAGE="https://github.com/hashcat/princeprocessor"
SRC_URI="https://github.com/hashcat/princeprocessor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/src"

src_prepare() {
	sed -i "s#-O2 -s#${CFLAGS} ${LDFLAGS}#" Makefile
	default
}

src_install() {
	newbin pp64.bin princeprocessor
	#install rules after hashcat is fixed
	#insinto /usr/share/hashcat
	#doins ../rules/*.rules
}
