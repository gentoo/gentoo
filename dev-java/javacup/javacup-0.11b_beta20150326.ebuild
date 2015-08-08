# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javacup/javacup-0.11b_beta20150326.ebuild,v 1.2 2015/08/08 01:05:15 sping Exp $

EAPI="5"

JAVA_PKG_IUSE="source doc"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="CUP Parser Generator for Java"

HOMEPAGE="http://www2.cs.tum.edu/projects/cup/"

# We cannot put the actual SRC_URI because it causes conflicts with Gentoo mirroring system
# No better URI is available, waiting until it hits actual Gentoo mirrors

MY_PV=${PV/_beta/-}
MY_PV=${MY_PV##0.}
SRC_URI="http://www2.cs.tum.edu/projects/cup/releases/java-cup-src-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="userland_BSD system-jflex"

# find for bug #214664
CDEPEND=">=dev-java/ant-core-1.7.0:0"
DEPEND=">=virtual/jdk-1.5
	system-jflex? ( dev-java/jflex:0 )
	!userland_BSD? ( >=sys-apps/findutils-4.4 )
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build-xml.patch

	find . -name '*.class' -delete || die

	if use system-jflex; then  # break the circular dependency
		rm bin/JFlex.jar || die
		java-pkg_jar-from --build-only jflex JFlex.jar bin/JFlex.jar
	fi

	java-ant_rewrite-classpath
}

src_compile() {
	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core)"
	rm bin/java-cup-11.jar || die
	cp dist/java-cup-11b.jar bin/java-cup-11.jar || die
	eant clean

	einfo "Recompiling with newly generated javacup"
	eant -Dgentoo.classpath="$(java-pkg_getjars ant-core)"
	use doc && javadoc -sourcepath src/ java_cup -d javadoc
}

src_install() {
	java-pkg_newjar dist/java-cup-11b.jar
	java-pkg_newjar dist/java-cup-11b-runtime.jar ${PN}-runtime.jar
	java-pkg_register-ant-task

	dodoc changelog.txt || die
	dohtml manual.html || die
	use source && java-pkg_dosrc java/*
	use doc && java-pkg_dojavadoc javadoc
}
