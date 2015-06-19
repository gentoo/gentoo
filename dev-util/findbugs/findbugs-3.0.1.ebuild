# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/findbugs/findbugs-3.0.1.ebuild,v 1.3 2015/05/18 19:46:20 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Find Bugs in Java Programs"
HOMEPAGE="http://findbugs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-java/ant-core:0
	dev-java/apple-java-extensions-bin:0
	dev-java/asm:4
	>=dev-java/bcel-6:0
	dev-java/commons-lang:2.1
	dev-java/dom4j:1
	dev-java/hamcrest-core:1.3
	dev-java/jaxen:1.1
	dev-java/jcip-annotations:0
	dev-java/jdepend:0
	>=dev-java/jformatstring-2.0.3:0
	dev-java/jsr305:0
	dev-java/junit:4"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-java/saxon:6.5
	)
	test? ( dev-java/ant-junit:0 )
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="apiJavadoc docs"
EANT_TEST_TARGET="runjunit"
EANT_GENTOO_CLASSPATH="ant-core,apple-java-extensions-bin,asm-4,bcel,commons-lang-2.1,dom4j-1,hamcrest-core-1.3,jaxen-1.1,jcip-annotations,jdepend,jformatstring,jsr305,junit-4"

pkg_setup() {
	java-pkg-2_pkg_setup
	use doc && EANT_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only --with-dependencies saxon-6.5)"
	EANT_EXTRA_ARGS="-Dgitrnum=gentoo -Dxsl.stylesheet.home=${EROOT}usr/share/sgml/docbook/xsl-stylesheets"
}

java_prepare() {
	epatch \
		"${FILESDIR}/0001-Support-bcel-6.0-RC3-instead-of-a-random-snapshot.patch" \
		"${FILESDIR}/0002-Don-t-bundle-anything-in-the-annotations-jar.patch" \
		"${FILESDIR}/0003-JDK-1.8-works-fine-for-me.patch" \
		"${FILESDIR}/0004-Don-t-clean-before-generating-docs.patch" \
		"${FILESDIR}/0005-Don-t-require-git-to-build.patch"

	# Remove bundled jars.
	find -name "*.jar" -delete || die
}

src_install() {
	java-pkg_dojar lib/{${PN},${PN}-ant,annotations}.jar

	insinto "/usr/share/${PN}/plugin"
	doins plugin/README

	use source && java-pkg_dosrc src/*/edu

	if use doc; then
		insinto "/usr/share/doc/${PF}/html/web"
		doins -r build/doc/*
		java-pkg_dojavadoc apiJavaDoc
	fi

	local SCRIPT CLASS
	local ARGS="-Dfindbugs.home=${EROOT}usr/share/findbugs"

	ls src/scripts/standard | grep -E -v '^(findbugs2?|fb|fbwrap)$' | while read SCRIPT; do
		CLASS=$(grep '^fb_mainclass=' "src/scripts/standard/${SCRIPT}" | sed 's/^.*=//')
		java-pkg_dolauncher "findbugs-${SCRIPT#findbugs-}" \
			--java_args "${ARGS}" --main "${CLASS}"
	done

	for SCRIPT in findbugs{,2} fb{,wrap}; do
		java-pkg_dolauncher "${SCRIPT}" \
			--java_args "\$fb_jvmargs ${ARGS}" --main '$fb_mainclass' \
			-pre "${FILESDIR}/launchers/${SCRIPT}"
	done
}

src_test() {
	java-pkg-2_src_test
}

pkg_postinst() {
	elog "findbugs ships with many launcher scripts. Most of these have been"
	elog "installed with a findbugs- prefix to avoid conflicts and confusion"
	elog "with other executables in the PATH."
}
