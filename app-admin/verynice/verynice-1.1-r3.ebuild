# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils systemd toolchain-funcs

DESCRIPTION="A tool for dynamically adjusting the nice-level of processes"
HOMEPAGE="https://web.archive.org/web/20130621090315/ http://thermal.cnde.iastate.edu/~sdh4/verynice/"
SRC_URI="http://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	default
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	tc-export CC
	emake RPM_BUILD_ROOT="${D}" PREFIX=/usr
}

src_install(){
	emake RPM_BUILD_ROOT="${D}" PREFIX=/usr VERSION=${PVR} install
	doinitd "${FILESDIR}"/verynice
	systemd_dounit "${FILESDIR}"/verynice.service
}
