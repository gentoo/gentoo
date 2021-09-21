# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="synchronize a cron job across multiple hosts using the consul lock feature"
HOMEPAGE="https://github.com/Barzahlen/cronlocker"
SRC_URI="https://github.com/Barzahlen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build -o cronlocker . || die
}

src_install() {
	dobin cronlocker
	dodoc *.md package/changelog
}
