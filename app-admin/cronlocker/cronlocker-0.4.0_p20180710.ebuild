# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/Barzahlen/cronlocker
HASH=c0ac605
inherit golang-vcs-snapshot

DESCRIPTION="synchronize a cron job across multiple hosts using the consul lock feature"
HOMEPAGE="https://github.com/Barzahlen/cronlocker"
SRC_URI="https://github.com/Barzahlen/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" emake cronlocker
}

src_install() {
	pushd src/${EGO_PN}
dobin cronlocker
dodoc *.md package/changelog
}
