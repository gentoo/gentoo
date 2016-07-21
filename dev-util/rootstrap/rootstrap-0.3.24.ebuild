# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

PATCH_LEVEL=3

DESCRIPTION="A tool for building complete Linux filesystem images"
HOMEPAGE="http://packages.qa.debian.org/rootstrap"
SRC_URI="mirror://debian/pool/main/r/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${PV}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-util/debootstrap
	dev-lang/python
	app-arch/dpkg"
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils"

RESTRICT="test"

S="${WORKDIR}"/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PN}_${PV}-${PATCH_LEVEL}.diff
	sed -i -e 's:docbook-to-man:docbook2man:' Makefile
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	newdoc debian/changelog ChangeLog
}
