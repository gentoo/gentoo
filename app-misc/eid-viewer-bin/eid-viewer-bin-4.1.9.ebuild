# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="${P/-bin/}"
SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Graphical interface to the Belgian Electronic Identity Card"

SRC_URI="https://downloads.services.belgium.be/eid/${MY_P}-v${PV}.src.tar.gz -> ${MY_P}.tar.gz"
HOMEPAGE="http://eid.belgium.be"

RDEPEND="
	virtual/jre:*
	sys-apps/pcsc-lite"
DEPEND="${RDEPEND}"

IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e 's:icons:pixmaps:' Makefile.in || die
	sed -i -e 's:Application;::' eid-viewer.desktop.sh.in || die
}
