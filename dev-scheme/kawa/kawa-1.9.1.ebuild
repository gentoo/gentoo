# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/kawa/kawa-1.9.1.ebuild,v 1.2 2008/03/30 20:28:09 maekke Exp $

inherit eutils java-pkg-2

DESCRIPTION="Kawa, the Java-based Scheme system"
HOMEPAGE="http://www.gnu.org/software/kawa/"
SRC_URI="mirror://gnu/kawa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_compile() {
	#copy of the default so that java-pkg-2 doesn't get used
	econf
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die
	rm -rv "${D}"/usr/share/java/ || die
	java-pkg_newjar kawa-${PV}.jar
	dodoc TODO README NEWS || die
	doinfo doc/kawa.info* || die
	java-pkg_dolauncher ${PN} --main kawa.repl
}
