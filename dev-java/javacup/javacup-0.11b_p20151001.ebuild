# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PV=${PV/_beta/-}
MY_PV=${MY_PV/_p/-}
MY_PV=${MY_PV#0.}
MY_P=java-cup-${MY_PV%-*}

DESCRIPTION="CUP Parser Generator for Java"
HOMEPAGE="http://www2.cs.tum.edu/projects/cup/"
SRC_URI="http://www2.cs.tum.edu/projects/cup/releases/java-cup-src-${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.7
	>=dev-java/ant-core-1.7.0:0
	>=dev-java/jflex-1.6.1:0"

RDEPEND=">=virtual/jre-1.7"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" taskdef"

S="${WORKDIR}"

java_prepare() {
	# Bizarrely, you can't build from the tarball without this patch.
	epatch "${FILESDIR}"/${PN}-0.11b_beta20150326-build-xml-svn.patch

	# The JFlex package name has changed to lower case.
	sed -i "s/JFlex\./jflex./g" build.xml || die

	# Remove the bundled JFlex.
	rm -v bin/JFlex.jar || die
}

src_configure() {
	EANT_GENTOO_CLASSPATH_EXTRA=$(java-pkg_getjars --build-only ant-core,jflex)
	java-ant-2_src_configure
}

src_compile() {
	# Annoyingly javacup bundles an older version of itself that will
	# break jflex if that has already been built against this newer
	# version beforehand. Even more annoyingly, the binary download is
	# built with Java 8, which isn't much use to us. We therefore use
	# any installed javacup that is newer than the bundled version where
	# possible. If this approach turns out to be unworkable then we may
	# just have to use the bundled jflex for bootstrapping.
	if has_version \>=${CATEGORY}/${PN}-0.11b:${SLOT}; then
		# Use PORTAGE_QUIET to suppress a QA warning that is spurious
		# thanks to has_version above. This is Portage-specific but
		# showing the warning elsewhere isn't the end of the world.
		einfo "Bootstrapping with installed javacup ..."
		EANT_GENTOO_CLASSPATH_EXTRA+=":$(PORTAGE_QUIET=1 java-pkg_getjars --build-only javacup)" eant
	else
		einfo "Bootstrapping with bundled javacup ..."
		EANT_GENTOO_CLASSPATH_EXTRA+=":${S}/bin/${MY_P:0:-1}.jar" eant
	fi

	# Clean everything except the new jar.
	rm -rv java/ classes/ || die

	einfo "Recompiling with newly built javacup ..."
	EANT_GENTOO_CLASSPATH_EXTRA+=":${S}/dist/${MY_P}.jar" eant

	use doc && ejavadoc -sourcepath src/ -d javadoc java_cup
}

src_install() {
	java-pkg_newjar dist/${MY_P}.jar
	java-pkg_newjar dist/${MY_P}-runtime.jar ${PN}-runtime.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
	java-pkg_register-ant-task

	dodoc changelog.txt
	docinto html
	dodoc manual.html

	use source && java-pkg_dosrc java/*
	use doc && java-pkg_dojavadoc javadoc
}
