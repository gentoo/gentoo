# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="simple local log4j vulnerability scanner"
HOMEPAGE="https://github.com/hillu/local-log4j-vuln-scanner"
SRC_URI="https://github.com/hillu/local-log4j-vuln-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build -o local-log4j-vuln-scanner ./scanner || die
	go build -o local-log4j-vuln-patcher ./patcher || die
}

src_install() {
	dobin local-log4j-vuln-{scanner,patcher}
	dodoc README.md
}
