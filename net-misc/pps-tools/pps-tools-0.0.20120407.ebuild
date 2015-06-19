# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pps-tools/pps-tools-0.0.20120407.ebuild,v 1.4 2012/12/23 23:09:03 vapier Exp $

EAPI="4"

inherit eutils

GITHUB_USER="ago"
PV_COMMIT='0deb9c7e135e9380a6d09e9d2e938a146bb698c8'

DESCRIPTION="User-space tools for LinuxPPS"
HOMEPAGE="http://wiki.enneenne.com/index.php/LinuxPPS_installation"
SRC_URI="http://github.com/${GITHUB_USER}/${PN}/tarball/${PV_COMMIT} -> ${PN}-git-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${GITHUB_USER}-${PN}-${PV_COMMIT:0:7}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-install.patch
	tc-export CC
}
