# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://protux.sourceforge.net/"
SRC_URI="http://${PN}.sourceforge.net/releases/${P}.tar.gz"

IUSE="source"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86"

DEPEND=">=virtual/jdk-1.5
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}

	# bug #318589
	sed -i '/com.sun.jmx.snmp.Enumerated/d' "${S}/src/org/protux/core/GlobalProperties.java" || die
}

src_compile() {
	cd src
	ejavac -encoding latin1 $(find . -name "*.java")
	jar cf ${PN}.jar $(find . -name "*.class") || die
}

src_install() {
	java-pkg_dojar src/${PN}.jar
	dodoc AUTHORS BUGLIST ChangeLog COPYRIGHT INSTALL README TODO || die
	use source && java-pkg_dosrc src/org
	# pwd like this because it does not find resources otherwise
	java-pkg_dolauncher ${PN} \
		--main org.protux.Main \
		--pwd /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r resources || die
}
