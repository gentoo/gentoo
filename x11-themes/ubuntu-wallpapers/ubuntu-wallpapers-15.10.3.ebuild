# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Ubuntu wallpapers"
HOMEPAGE="https://launchpad.net/ubuntu/+source/ubuntu-wallpapers"
MY_P="${PN}_${PV}"
SRC_URI="mirror://ubuntu/pool/main/u/${PN}/${MY_P}.orig.tar.gz"
LICENSE="CC-BY-SA-3.0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P/_/-}"

SLOT=0

src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/backgrounds
	doins *.jpg *.png

	insinto /usr/share/backgrounds/contest
	doins contest/*.xml

	for i in *.xml.in; do
		insinto /usr/share/gnome-background-properties
		newins ${i} ${i/.in/}
	done

	dodoc AUTHORS
}
