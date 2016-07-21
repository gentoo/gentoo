# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Secure, lightweight, international Bitcoin wallet written in Java"
HOMEPAGE="https://multibit.org/"
SRC_URI="https://multibit.org/releases/${P}/${P}-linux.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() { :; }

src_prepare() {
	cp "${FILESDIR}"/auto-install.xml "${WORKDIR}" || die
	sed -i "s:ED:${ED}:" auto-install.xml || die
}

src_install() {
	dobin "${FILESDIR}"/${PN}

	make_desktop_entry "${PN}" "Multibit" "/opt/MultiBit/multibit48.png" "GNOME;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/multibit;\nTerminal=false"

	java -jar "${DISTDIR}"/${P}-linux.jar auto-install.xml >/dev/null 2>&1
}
