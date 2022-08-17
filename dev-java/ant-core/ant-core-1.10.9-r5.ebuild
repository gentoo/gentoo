# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Don't depend on itself.
JAVA_ANT_DISABLE_ANT_CORE_DEP="true"

# Rewriting build.xml files for the testcases has no use at the moment.
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.ant:ant:1.10.9"

inherit java-pkg-2 java-ant-2 prefix

MY_P="apache-ant-${PV}"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files"
HOMEPAGE="https://ant.apache.org/"
SRC_URI="https://archive.apache.org/dist/ant/source/${MY_P}-src.tar.bz2
	https://dev.gentoo.org/~fordfrog/distfiles/ant-${PV}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CDEPEND=">=virtual/jdk-1.8:*"
DEPEND="${CDEPEND}
	doc? (
		dev-java/bcel:0
		dev-java/bsf:2.3
		dev-java/commons-logging:0
		dev-java/commons-net:0
		dev-java/jakarta-activation-api:1
		dev-java/jakarta-regexp:1.4
		dev-java/jakarta-oro:2.0
		dev-java/jdepend:0
		dev-java/jsch:0
		dev-java/log4j-12-api:2
		dev-java/javax-mail:0
		dev-java/sun-jai-bin:0
		dev-java/xalan:0
		dev-java/xml-commons-resolver:0
		dev-java/xz-java:0
	)"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

PATCHES=(
	"${WORKDIR}/${PV}-build.patch"
	"${WORKDIR}/${PV}-launch.patch"
)

src_prepare() {
	default

	eprefixify "${S}/src/script/ant"

	# Fixes bug 556008.
	java-ant_xml-rewrite -f build.xml \
		-c -e javadoc \
		-a failonerror \
		-v "false"

	# See bug #196080 for more details.
	java-ant_bsfix_one build.xml
	java-pkg-2_src_prepare

	# Remove JDK9+ stuff
	einfo "Removing JDK9+ classes (Jmod and Link)"
	rm "${S}"/src/main/org/apache/tools/ant/taskdefs/modules/{Jmod,Link}.java
}

src_compile() {
	export ANT_HOME=""
	# Avoid error message that package ant-core was not found
	export ANT_TASKS="none"

	local bsyscp

	# This ensures that when building ant with bootstrapped ant,
	# only the source is used for resolving references, and not
	# the classes in bootstrapped ant but jikes in kaffe has issues with this...
	if ! java-pkg_current-vm-matches kaffe; then
		bsyscp="-Dbuild.sysclasspath=ignore"
	fi

	CLASSPATH="$(java-config -t)" ./build.sh ${bsyscp} jars dist-internal ||
		die "build failed"

	if use doc; then
		# All Java packages imported by the source files need to present in
		# the classpath, otherwise it would be https://bugs.gentoo.org/780531
		local doc_deps=(
			bcel
			bsf-2.3
			commons-logging
			commons-net
			jakarta-activation-api-1
			jakarta-oro-2.0
			jakarta-regexp-1.4
			jdepend
			jsch
			log4j-12-api-2
			javax-mail
			sun-jai-bin
			xalan
			xml-commons-resolver
			xz-java
		)
		for dep in "${doc_deps[@]}"; do
			java-pkg_jar-from --build-only --into lib/optional/ "${dep}"
		done
		# This file imports netrexx.lang.Rexx, which is not available
		# from ::gentoo.  Fortunately, there is not a dev-java/ant-*
		# package for it, so even if we could generate documentation
		# for it, it would be irrelevant
		rm src/main/org/apache/tools/ant/taskdefs/optional/NetRexxC.java ||
			die "Failed to remove Java source file blocking Javadoc generation"
		./build.sh ${bsyscp} javadocs || die "Javadoc build failed"
	fi
}

src_install() {
	dodir /usr/share/ant/lib

	for jar in ant.jar ant-bootstrap.jar ant-launcher.jar ; do
		java-pkg_dojar build/lib/${jar}
		dosym ../../${PN}/lib/${jar} /usr/share/ant/lib/${jar}
	done

	dobin src/script/ant

	dodir /usr/share/${PN}/bin
	for each in antRun antRun.pl runant.pl runant.py ; do
		dobin "${S}/src/script/${each}"
		dosym ../../../bin/${each} /usr/share/${PN}/bin/${each}
	done
	dosym ../${PN}/bin /usr/share/ant/bin

	insinto /usr/share/${PN}
	doins -r dist/etc
	dosym ../${PN}/etc /usr/share/ant/etc

	echo "ANT_HOME=\"${EPREFIX}/usr/share/ant\"" > "${T}/20ant"
	doenvd "${T}/20ant"

	dodoc NOTICE README WHATSNEW KEYS

	if use doc; then
		dodoc -r manual/*
		java-pkg_dojavadoc --symlink manual/api build/javadocs
	fi

	use source && java-pkg_dosrc src/main/*
}
