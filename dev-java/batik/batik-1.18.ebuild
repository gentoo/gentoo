# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.xmlgraphics:batik:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit desktop java-pkg-2 java-pkg-simple xdg-utils verify-sig

DESCRIPTION="XML Graphics Batik"
HOMEPAGE="https://xmlgraphics.apache.org/batik/"
SRC_URI="mirror://apache/xmlgraphics/batik/source/batik-src-${PV}.tar.gz
	verify-sig? ( https://downloads.apache.org/xmlgraphics/batik/source/batik-src-${PV}.tar.gz.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="
	app-arch/zip
	verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics-batik )
"

CP_DEPEND="
	dev-java/jacl:0
	dev-java/rhino:1.6
	dev-java/xalan:0
	dev-java/xml-commons-external:1.4
	dev-java/xmlgraphics-commons:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/xmlgraphics-batik.apache.org.asc"

DOCS=( CHANGES NOTICE README )

# Modules batik-rasterizer-ext and batik-squiggle-ext, upstream puts their jar files in the extensions
# directory, see batik-extension/src/main/resources/org/apache/batik/extensions/README.txt
# We comment them out but keep them in the mudules list for later.
# The same for batik-test-old which depends on fop-transcoder-allinone which itself depends on batik.
# We also don't build batik-shared-resources since we install those resources on global scope.
# And we don't build batik-all. Instead we install the modules.
# BATIK_MODULES is the "Reactor Build Order" extracted from the output of "mvn dependency:tree":
#	mvn -DskipTests dependency:tree \
#		| sed -n '/Reactor Build Order:/,/Building org/p' \
#		| cut -d':' -f2 | cut -d' ' -f1 | grep 'batik-' || die
BATIK_MODULES=(
#	batik-shared-resources
	batik-constants
	batik-i18n
	batik-test
	batik-util
	batik-awt-util
	batik-css
	batik-ext
	batik-xml
	batik-dom
	batik-parser
	batik-svg-dom
	batik-anim
	batik-gvt
	batik-script
	batik-bridge
	batik-svggen
	batik-transcoder
	batik-codec
	batik-extension
	batik-gui-util
	batik-svgrasterizer
#	batik-rasterizer-ext
	batik-rasterizer
	batik-slideshow
	batik-swing
	batik-svgbrowser
#	batik-squiggle-ext
	batik-squiggle
	batik-svgpp
	batik-ttf2svg
#	batik-all
	batik-test-swing
	batik-test-svg
#	batik-test-old
)

src_prepare() {
	java-pkg_clean
	java-pkg-2_src_prepare
	# We drop support for jython due to bug #825486.
	rm batik-script/src/main/java/org/apache/batik/script/jpython/JPythonInterpreter.java || die
	rm batik-script/src/main/java/org/apache/batik/script/jpython/JPythonInterpreterFactory.java || die

	cat > "batik-squiggle-${SLOT}.desktop" <<-EOF || die
		[Desktop Entry]
		Name=Squiggle
		Comment=SVG browser
		Exec=batik-squiggle-${SLOT}
		Icon=init
		Terminal=false
		Type=Application
		Categories=Graphics;VectorGraphics;
		MimeType=image/svg+xml
	EOF
}

src_compile() {
	# We loop over the modules list and compile the jar files.
	local module
	for module in "${BATIK_MODULES[@]}"; do
		einfo "Compiling ${module}"

		JAVA_JAR_FILENAME="${module}.jar"
		JAVA_MAIN_CLASS=""
		JAVA_RESOURCE_DIRS=""
		JAVA_SRC_DIR=""

		# Not all of the modules have resources.
		if [[ -d "${module}/src/main/resources" ]]; then
			JAVA_RESOURCE_DIRS="${module}/src/main/resources"
		fi

		# Get Main-Class from the module's pom.xml
		JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' "${module}/pom.xml" )

		# Some modules don't have source code.
		if [[ -d "${module}/src/main/java/org" ]]; then
			JAVA_SRC_DIR="${module}/src/main/java"
			java-pkg-simple_src_compile
		else
			# This case applies to batik-rasterizer.
			if [[ -d "${module}/src/main/resources/org" ]]; then
				jar -cfe "${module}.jar" "${JAVA_MAIN_CLASS}" -C "${module}/src/main/resources" . || die
			# Else for batik-squiggle (also batik-rasterizer-ext, batik-squiggle-ext)
			else
				# Create the JAR file (not possible without adding at least one file).
				jar -cfe "${module}.jar" "${JAVA_MAIN_CLASS}" -C . README || die
				zip -d "${module}.jar" "README" || die
			fi
		fi

		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"

		rm -fr target || die
	done

	if use doc; then
		JAVA_SRC_DIR=""
		JAVA_JAR_FILENAME="ignoreme.jar"

		for module in "${BATIK_MODULES[@]}"; do
			# Some modules don't have source code
			if [[ -d "${module}/src/main/java/org" ]]; then
				JAVA_SRC_DIR+=( "${module}/src/main/java" )
			fi
		done

		java-pkg-simple_src_compile
	fi
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"

	for module in "${BATIK_MODULES[@]}"; do
		einfo "Testing ${module}"

		JAVA_TEST_SRC_DIR=""
		JAVA_TEST_RESOURCE_DIRS=""
		JAVA_TEST_RUN_ONLY=""

		if [[ -d "${module}/src/test/resources" ]]; then
			JAVA_TEST_RESOURCE_DIRS="${module}/src/test/resources"
		fi

		# https://github.com/apache/xmlgraphics-batik/blob/refs/tags/batik-1_14/batik-util/pom.xml#L74-L75
		if [[ "${module}" == batik-util ]]; then
			JAVA_TEST_RUN_ONLY="org.apache.batik.util.Base64TestCases"
		fi

		if [[ -d "${module}/src/test/java/org" ]]; then
			JAVA_TEST_SRC_DIR="${module}/src/test/java"
			java-pkg-simple_src_test
		fi
	done
}

src_install() {
	einstalldocs
	domenu "batik-squiggle-${SLOT}.desktop"
	newicon -s scalable \
		batik-svgbrowser/src/main/resources/org/apache/batik/apps/svgbrowser/resources/init.svg \
		squiggle-${SLOT}.svg

	for module in "${BATIK_MODULES[@]}"; do
		JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' "${module}/pom.xml" )

		java-pkg_dojar "${module}.jar"

		# Add a launcher if the module has a MainClass.
		if [[ -n "${JAVA_MAIN_CLASS}" ]]; then
			java-pkg_dolauncher "${module}-${SLOT}" --main "${JAVA_MAIN_CLASS}"
		fi

		# Some modules don't have source code
		if [[ -d "${module}/src/main/java/org" ]]; then
			if use source; then
				java-pkg_dosrc "${module}/src/main/java/*"
			fi
		fi
	done

	local java_policy_file="${JAVA_PKG_SHAREPATH}/etc/${PN}.policy"
	insinto "$(dirname "${java_policy_file}")"
	newins - "$(basename "${java_policy_file}")" <<- _EOF_
		grant codeBase "file:${EPREFIX}${JAVA_PKG_JARDEST}/-" {
			permission java.security.AllPermission;
		};
	_EOF_
	java-pkg_register-environment-variable \
		gjl_java_args \
		"\$gjl_java_args -Djava.security.policy=file:${EPREFIX}${java_policy_file}"

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
