# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker eutils

DESCRIPTION="shell script that generates a self-extractible tar.gz"
HOMEPAGE="http://www.megastep.org/makeself/"
SRC_URI="https://github.com/megastep/makeself/archive/release-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-apps/gentoo-functions"

S="${WORKDIR}/${PN}-release-${PV}"

PATCHES=( "${FILESDIR}/${P}-help-header.patch" )

src_install() {
	dobin makeself-header.sh makeself.sh "${FILESDIR}"/makeself-unpack
	dosym makeself.sh /usr/bin/makeself
	doman makeself.1
	dodoc README.md makeself.lsm
}
