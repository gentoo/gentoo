# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"
S="${WORKDIR}/${P/p/P}"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

src_install() {
	dobin bin/${PN}
}
