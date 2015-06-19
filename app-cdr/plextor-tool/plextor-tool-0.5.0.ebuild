# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/plextor-tool/plextor-tool-0.5.0.ebuild,v 1.5 2013/08/27 14:06:50 ssuominen Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Tool to change the parameters of a Plextor CD-ROM drive"
HOMEPAGE="http://plextor-tool.sourceforge.net/"
SRC_URI="mirror://sourceforge/plextor-tool/${P}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

S=${WORKDIR}/${PN}/src

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	gunzip plextor-tool.8.gz || die
}

src_compile() {
	local targets="plextor-tool"
	use static && targets="${targets} pt-static"
	echo ${targets} > my-make-targets
	emake CC="$(tc-getCC)" ${targets}
}

src_install() {
	local targets=$(<my-make-targets)
	dodoc ../doc/{NEWS,README} TODO
	dobin ${targets}
	doman plextor-tool.8
}
