# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/xmlgraphics/batik/source/batik-src-1.14.tar.gz --slot 1.14 --keywords "~amd64 ~ppc64 ~x86" --ebuild batik-1.14.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:batik:1.14"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit desktop java-pkg-2 java-pkg-simple xdg-utils

DESCRIPTION="XML Graphics Batik"
HOMEPAGE="https://xmlgraphics.apache.org/batik/"
SRC_URI="mirror://apache/xmlgraphics/batik/source/batik-src-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.14"
KEYWORDS="~amd64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jacl:0
	dev-java/jython:2.7
	dev-java/rhino:1.6
	dev-java/xalan:0
	dev-java/xml-commons-external:1.3
	dev-java/xmlgraphics-commons:2
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CHANGES,NOTICE,README} )

S="${WORKDIR}/batik-${PV}"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {

	# We loop over the modules list and compile the jar files.
	while read module ; do \

		echo "compiling $module"

		JAVA_SRC_DIR=""
		JAVA_RESOURCE_DIRS=""
		JAVA_JAR_FILENAME="$module.jar"
		JAVA_MAIN_CLASS=""

		# Not all of the modules have resources.
		if [[ -d $module/src/main/resources ]]; then \
			JAVA_RESOURCE_DIRS="$module/src/main/resources"
		fi

		# Don't let sed die on modules without MainClass.
		JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' $module/pom.xml )

		# Some modules don't have source code.
		if [[ -d $module/src/main/java/org ]]; then \
			JAVA_SRC_DIR="$module/src/main/java"
			java-pkg-simple_src_compile
		else
			# This case applies to batik-rasterizer.
			if [[ -d $module/src/main/resources/org ]]; then \
				jar -cfe $module.jar "${JAVA_MAIN_CLASS}" -C "$module/src/main/resources" . || die
			# Else for batik-rasterizer-ext, batik-squiggle and batik-squiggle-ext
			else
				jar -cfe $module.jar "${JAVA_MAIN_CLASS}" -C . README || die
				zip -d $module.jar "README"
			fi
		fi

		JAVA_GENTOO_CLASSPATH_EXTRA+=":$module.jar"

		rm -fr target || die

	# Modules batik-rasterizer-ext and batik-squiggle-ext, upstream puts their jar files in the extensions
	# directory, see batik-extension/src/main/resources/org/apache/batik/extensions/README.txt
	# We keep them in the mudules list for later but omit them by 'grep -v'.
	# The same for batik-test-old which depends on fop-transcoder-allinone which itself depends on batik.
	# batik-1.14-modules is the "Reactor Build Order" extracted from the output of "mvn dependency:tree".
	done < <(grep -v '\(batik-rasterizer-ext\|batik-squiggle-ext\|batik-test-old\)' "${FILESDIR}"/batik-1.14-modules)

	if use doc; then

		JAVA_SRC_DIR=""
		JAVA_JAR_FILENAME="ignoreme.jar"

		while read module ; do \

			# Some modules don't have source code
			if [[ -d $module/src/main/java/org ]]; then \
				JAVA_SRC_DIR+=( "$module/src/main/java" )
			fi

		done < "${FILESDIR}"/batik-1.14-modules

		java-pkg-simple_src_compile
	fi
}

src_test() {

	JAVA_TEST_GENTOO_CLASSPATH="junit-4"

	while read module ; do \

		echo "testing $module"

		JAVA_TEST_SRC_DIR=""
		JAVA_TEST_RESOURCE_DIRS=""
		JAVA_TEST_RUN_ONLY=""

		if [[ -d $module/src/test/resources ]]; then \
			JAVA_TEST_RESOURCE_DIRS="$module/src/test/resources"
		fi

		# https://github.com/apache/xmlgraphics-batik/blob/refs/tags/batik-1_14/batik-util/pom.xml#L74-L75
		if [[ $module == batik-util ]]; then \
			JAVA_TEST_RUN_ONLY="org.apache.batik.util.Base64TestCases"
		fi

		if [[ -d $module/src/test/java/org ]]; then \
			JAVA_TEST_SRC_DIR="$module/src/test/java"
			java-pkg-simple_src_test
		fi

	done < <(grep -v '\(batik-rasterizer-ext\|batik-squiggle-ext\|batik-test-old\)' "${FILESDIR}"/batik-1.14-modules)
}

src_install() {
	einstalldocs
	domenu "${FILESDIR}"/batik-squiggle.desktop
	doicon batik-svgbrowser/src/main/resources/org/apache/batik/apps/svgbrowser/resources/init.svg

	while read module ; do \

		JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' $module/pom.xml )

		java-pkg_dojar $module.jar

		# Add a launcher if the module has a MainClass.
		if [[ -n "${JAVA_MAIN_CLASS}" ]]; then \
			java-pkg_dolauncher "$module-${SLOT}" --main "${JAVA_MAIN_CLASS}"
		fi

		# Some modules don't have source code
		if [[ -d $module/src/main/java/org ]]; then \

			if use source; then
				java-pkg_dosrc "$module/src/main/java/*"
			fi

		fi

	done < <(grep -v '\(batik-rasterizer-ext\|batik-squiggle-ext\|batik-test-old\)' "${FILESDIR}"/batik-1.14-modules)

	local java_policy_file="${JAVA_PKG_SHAREPATH}/etc/${PN}.policy"
	insinto "$(dirname "${java_policy_file}")"
	newins - "$(basename "${java_policy_file}")" <<- _EOF_
		grant codeBase "file:${EPREFIX}${JAVA_PKG_JARDEST}/-" {
			permission java.security.AllPermission;
		};
	_EOF_
	java-pkg_register-environment-variable \
		gjl_java_args \
		"-Djava.security.policy=file:${EPREFIX}${java_policy_file}"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
