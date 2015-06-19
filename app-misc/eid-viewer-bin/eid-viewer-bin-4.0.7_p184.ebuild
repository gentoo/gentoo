# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/eid-viewer-bin/eid-viewer-bin-4.0.7_p184.ebuild,v 1.2 2014/08/10 18:03:21 slyfox Exp $

EAPI=5

inherit eutils

MY_PN="eid-viewer"
MY_PV="${PV%%_p*}"
#MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Graphical interface to the Belgian Electronic Identity Card"

SRC_URI="http://eid.belgium.be/en/binaries/eid-viewer-4%2E0%2E7-184%2Esrc%2Etar_tcm406-250014.gz -> eid-viewer-4.0.7_p184.tar.gz"
HOMEPAGE="http://eid.belgium.be"

RDEPEND="
	virtual/jre
	sys-apps/pcsc-lite"
DEPEND="${RDEPEND}"

IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e 's:icons:pixmaps:' Makefile.in || die
	sed -i -e 's:Application;::' eid-viewer.desktop.sh.in || die
}
