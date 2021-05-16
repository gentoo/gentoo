# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://protux.sourceforge.net/"
SRC_URI="http://${PN}.sourceforge.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="source"

DEPEND=">=virtual/jdk-1.5
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	# bug #318589
	sed -i '/com.sun.jmx.snmp.Enumerated/d' \
		src/org/protux/core/GlobalProperties.java || die
}

src_compile() {
	cd src || die
	ejavac -encoding latin1 $(find . -name "*.java")
	jar cf ${PN}.jar $(find . -name "*.class") || die
}

src_install() {
	java-pkg_dojar src/${PN}.jar
	dodoc AUTHORS BUGLIST ChangeLog COPYRIGHT INSTALL README TODO
	use source && java-pkg_dosrc src/org
	# pwd like this because it does not find resources otherwise
	java-pkg_dolauncher ${PN} \
		--main org.protux.Main \
		--pwd /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r resources
}
