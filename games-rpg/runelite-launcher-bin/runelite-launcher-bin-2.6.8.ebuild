# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Popular third-party client for OldSchool RuneScape"
HOMEPAGE="https://runelite.net/"
SRC_URI="https://github.com/runelite/launcher/releases/download/${PV}/RuneLite.jar"
S="${WORKDIR}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"

RDEPEND="
	virtual/jre:11
"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_compile() {
	:;
}

src_install() {
	newbin "${FILESDIR}"/runelite-launcher-bin runelite
	java-pkg_newjar RuneLite.jar
}
