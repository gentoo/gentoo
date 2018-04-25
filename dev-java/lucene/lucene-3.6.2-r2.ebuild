# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test contrib"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml contrib-build.xml"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/${PV}/${P}-src.tgz"

LICENSE="Apache-2.0"
SLOT="3.6"
KEYWORDS="amd64 x86"

CDEPEND="
	dev-java/ant-ivy:2
	dev-java/ant-junit:0
	dev-java/ant-core:0
	dev-java/hamcrest-core:0
	contrib? (
	          dev-java/jakarta-regexp:1.4
			  dev-java/commons-compress:0
	          dev-java/commons-collections:0
	          dev-java/commons-digester:0
	          dev-java/commons-logging:0
			  dev-java/commons-beanutils:1.7
	)"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/junit:4
	)"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DOCS=(
	CHANGES.txt README.txt
	NOTICE.txt CHANGES.txt
	JRE_VERSION_MIGRATION.txt
)

# All tests fail with the following error:
# junit.framework.AssertionFailedError: ensure your setUp() calls super.setUp()!!!
RESTRICT="test"

src_prepare() {
	default
	java-pkg_clean
	sed -i \
		-e '/-Xmax/ d' \
		common-build.xml || die

	# FIXME: contrib builds do not work if junit not included
	#java-pkg_jar-from --build-only --into lib \
	#	junit-4 junit.jar junit-4.7.jar
	java-pkg_jar-from --build-only --into lib \
		ant-core ant.jar ant-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		ant-junit ant-junit.jar ant-junit-1.7.1.jar

	if use contrib; then
	  cd contrib/ || die
	  java-pkg_jar-from --build-only --into queries/lib \
	  	jakarta-regexp:1.4 jakarta-regexp.jar jakarta-regexpt-1.4.jar
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
	fi
}

src_prepare() {
	default
	java-pkg_clean
	sed -i \
		-e '/-Xmax/ d' \
		-e '/property="ivy.available"/s,resource="${ivy.resource}",file="." type="dir",g' \
		-e '/<ivy:retrieve/d' \
		common-build.xml || die
	mkdir -p {.,queries,benchmark,analyzers/phonetic}/lib || die
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
	cd "${S}"/test-framework/ || die
	java-pkg_jar-from --build-only --into lib \
		ant-core ant.jar ant-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		ant-junit ant-junit.jar ant-junit-1.7.1.jar
	java-pkg_jar-from --build-only --into lib \
		junit-4 junit.jar junit-4.10.jar
	java-pkg_jar-from --build-only --into lib \
		hamcrest-core

	if use contrib; then
	    cd "${S}"/contrib/ || die
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
	java-ant_xml-rewrite -f common-build.xml \
		-c -e javadoc \
		-a failonerror \
		-v "false"

	ANT_TASKS="none" \
		eant -Dversion=${PV} \
		-Dfailonjavadocwarning=false \
		jar-core \
		$(use_doc javadocs-core)

	if use contrib; then
		ANT_TASKS="none" \
			eant -Dversion=${PV} \
			-Dfailonjavadocwarning=false \
			build-contrib \
			$(use_doc javadocs-all)
	fi
}

src_test() {
	# FIXME: test does not get run, even when selected
	java-ant_rewrite-classpath common-build.xml
	EANT_GENTOO_CLASSPATH="junit-4 ant-core ant-junit" \
		ANT_TASKS="ant-junit" \
		eant test-core
}

src_install() {
	einstalldocs
	java-pkg_newjar build/core/${PN}-core-${PV}.jar ${PN}-core.jar

	if use contrib; then
		local i j
		for i in $(find build/contrib -name \*-${PV}.jar); do
		    j=${i##*/}
			java-pkg_newjar $i ${j%%-${PV}.jar}.jar
		done
	fi
	if use doc; then
		dodoc -r docs
		java-pkg_dohtml -r build/docs/api
	fi
	if use source; then
	     java-pkg_dosrc core/src/java/org
	  	 use contrib && java-pkg_dosrc contrib
	fi
}
