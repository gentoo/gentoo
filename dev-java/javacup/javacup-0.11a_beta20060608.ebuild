# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javacup/javacup-0.11a_beta20060608.ebuild,v 1.16 2015/07/11 09:20:21 chewi Exp $

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="CUP Parser Generator for Java"

HOMEPAGE="http://www2.cs.tum.edu/projects/cup/"

# We cannot put the actual SRC_URI because it causes conflicts with Gentoo mirroring system
# No better URI is available, waiting until it hits actual Gentoo mirrors

#SRC_URI="https://www2.in.tum.de/WebSVN/dl.php?repname=CUP&path=/develop/&rev=0&isdir=1"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="userland_BSD"

# find for bug #214664
DEPEND=">=virtual/jdk-1.4
	!userland_BSD? ( >=sys-apps/findutils-4.4 )"
RDEPEND=">=virtual/jre-1.4
		>=dev-java/ant-core-1.7.0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	find . -name "*.class" -delete || die
	java-ant_rewrite-classpath
}

src_compile() {
	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core)"
	rm bin/java-cup-11.jar
	cp dist/java-cup-11a.jar bin/java-cup-11.jar
	eant clean
	einfo "Recompiling with newly generated javacup"
	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core)"
	use doc && javadoc -sourcepath src/ java_cup -d javadoc
}

src_install() {
	java-pkg_newjar dist/java-cup-11a.jar
	java-pkg_newjar dist/java-cup-11a-runtime.jar ${PN}-runtime.jar
	java-pkg_register-ant-task

	dodoc changelog.txt || die
	dohtml manual.html || die
	use source && java-pkg_dosrc java/*
	use doc && java-pkg_dojavadoc javadoc
}
