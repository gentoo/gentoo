# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/probe/probe-2.12.110413.ebuild,v 1.7 2012/07/10 17:59:09 ranger Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Evaluates atomic packing within or between molecules"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/probe.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/probe/${MY_P}.src.zip"

SLOT="0"
LICENSE="richardson"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/trunk

src_prepare() {
	epatch "${FILESDIR}"/${PV}-as-needed.patch
	# Respect CC
	sed -i \
		-e 's:cc:$(CC):g' \
		"${S}"/Makefile || die
	tc-export CC
}

src_install() {
	dobin "${S}"/probe
	dodoc "${S}"/README*
}
