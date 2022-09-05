# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/angus-mail/archive/1.0.0.tar.gz --slot 0 --keywords "~amd64" --ebuild angus-mail-1.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.eclipse.angus:angus-mail:1.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Angus Mail Project"
HOMEPAGE="https://eclipse-ee4j.github.io/mail/"
SRC_URI="https://github.com/eclipse-ee4j/angus-mail/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/angus-activation:0
	dev-java/jakarta-activation-api:2
	dev-java/jakarta-mail-api:0
"

DEPEND=">=virtual/jdk-11:*
	${CP_DEPEND}"
RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/${P}"

ANGUS_MAIL_MODULES=(
	"angus-core"
	"providers/imap"
	"providers/smtp"
	"providers/pop3"
	"logging-mailhandler"
	"providers/angus-mail"
)

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
	mv {,angus-}core || die
	mv {,logging-}mailhandler || die
}

src_compile() {
	local module
	for module in "${ANGUS_MAIL_MODULES[@]}"; do
		JAVA_RESOURCE_DIRS=()
		JAVA_SRC_DIR=()
		einfo "Compiling ${module}"
		JAVA_JAR_FILENAME="$module.jar"
		# Not all of the modules have resources.
		if [[ -d $module/src/main/resources ]]; then \
			JAVA_RESOURCE_DIRS="$module/src/main/resources"
		fi
		JAVA_SRC_DIR="$module/src/main/java"
		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":$module.jar"
	done
}

src_test() {
	JAVA_TEST_EXTRA_ARGS=( -ea )
	JAVA_TEST_GENTOO_CLASSPATH="junit-4"
	JAVA_TEST_RESOURCE_DIRS="providers/angus-mail/src/test/resources"
	JAVA_TEST_SRC_DIR="providers/angus-mail/src/test/java"
	pushd providers/angus-mail/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-name "*Test.java" \
			! -name "MailHandlerTest.java" \
			! -name "ParametersNoStrictTest.java" \
			! -name "NoEncodeFileNameNoEncodeParametersTest.java" \
			! -name "EncodeFileNameTest.java" \
			! -name "EncodeFileNameNoEncodeParametersTest.java" \
			! -name "ContentTypeCleanerTest.java" \
			! -name "LineInputStreamUtf8Test.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd
	java-pkg-simple_src_test
}
