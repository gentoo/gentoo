# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
JAVA_PKG_IUSE="doc source test contrib"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml contrib-build.xml"
#JAVA_PKG_DEBUG=1

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine library
written entirely in Java"
HOMEPAGE="http://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/${PV}/${P}-src.tgz"
LICENSE="Apache-2.0"
SLOT="${PV:0:3}"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=virtual/jdk-1.5
	contrib? (
			  dev-java/commons-beanutils:1.7
			  >=dev-java/commons-codec-1.6:0
	          dev-java/commons-collections:0
			  dev-java/commons-compress:0
	          dev-java/commons-digester:0
	          dev-java/commons-logging:0
	          dev-java/jakarta-regexp:1.4
	)"
DEPEND="${RDEPEND}
	dev-java/ant-nodeps:0
	test? ( =dev-java/junit-4.10*:4
			dev-java/hamcrest-core )
	dev-java/ant-junit:0
	>=dev-java/ant-ivy-2.2.0:2"

#dev-java/javacc:0 - no longer needed, files are prebuilt

java_prepare() {
	#find -name "*.jar" -type f | xargs rm -v
	sed -i \
		-e '/-Xmax/ d' \
		-e '/property="ivy.available"/s,resource="${ivy.resource}",file="." type="dir",g' \
		-e '/<ivy:retrieve/d' \
		common-build.xml
	mkdir -p {.,queries,benchmark,analyzers/phonetic}/lib
	java-pkg_jar-from --build-only --into lib \
		ant-core ant.jar ant-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		ant-junit ant-junit.jar ant-junit-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		ant-ivy:2
	java-pkg_jar-from --build-only --into lib \
		junit-4 junit.jar junit-4.10.jar
	java-pkg_jar-from --build-only --into lib \
		hamcrest-core
	# Always needed anyway
	cd "${S}"/test-framework/
	java-pkg_jar-from --build-only --into lib \
		ant-core ant.jar ant-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		ant-junit ant-junit.jar ant-junit-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		junit-4 junit.jar junit-4.10.jar
	java-pkg_jar-from --build-only --into lib \
		hamcrest-core

	if use contrib ; then
	    cd "${S}"/contrib/
		# queries
	    java-pkg_jar-from --build-only --into queries/lib \
	    	jakarta-regexp:1.4 jakarta-regexp.jar jakarta-regexp-1.4.jar
		# benchmark
	    java-pkg_jar-from --build-only --into benchmark/lib \
	    	commons-compress commons-compress.jar commons-compress-1.1.jar
	    java-pkg_jar-from --build-only --into benchmark/lib \
	    	commons-collections commons-collections.jar commons-collections-3.1.jar
	    java-pkg_jar-from --build-only --into benchmark/lib \
	    	commons-digester commons-digester.jar commons-digester-1.7.jar
	    java-pkg_jar-from --build-only --into benchmark/lib \
	    	commons-logging commons-logging.jar commons-logging-1.0.4.jar
	    java-pkg_jar-from --build-only --into benchmark/lib \
	    	commons-beanutils:1.7 commons-beanutils.jar commons-beanutils-1.7.0.jar
		# analyzers/phonetic
	    java-pkg_jar-from --build-only --into analyzers/phonetic/lib \
	    	commons-codec commons-codec.jar commons-codec-1.6.jar
	fi
}

src_compile() {
	# FIXME: docs do not build if behind a proxy, -autoproxy does not work
	einfo "Building main"
	ANT_TASKS="none" eant -Dversion=${PV} \
		-Dfailonjavadocwarning=false \
		jar-core $(use_doc javadocs-core )
	if use contrib ; then
	  einfo "Building contrib"
	 ANT_TASKS="none" eant -Dversion=${PV} \
		-Dfailonjavadocwarning=false \
		build-contrib $(use_doc javadocs-all )
	fi
}

src_test() {
	# FIXME: test does not get run, even when selected
	java-ant_rewrite-classpath common-build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core ant-junit" ANT_TASKS="ant-junit" eant test-core
}

src_install() {
	dodoc CHANGES.txt README.txt NOTICE.txt CHANGES.txt \
	    JRE_VERSION_MIGRATION.txt|| die
	java-pkg_newjar build/core/${PN}-core-${PV}.jar ${PN}-core.jar
	if use contrib; then
		for i in `find  build/contrib -name \*-${PV}.jar`
		do
		    j=${i##*/}
			java-pkg_newjar $i ${j%%-${PV}.jar}.jar
		done
	fi
	if use doc; then
		dohtml -r docs/* || die
		java-pkg_dohtml -r build/docs/api
	fi
	if use source; then
	     java-pkg_dosrc core/src/java/org || die
	  	 if use contrib; then
	    	java-pkg_dosrc  contrib  || die
	  	 fi
	fi
}
