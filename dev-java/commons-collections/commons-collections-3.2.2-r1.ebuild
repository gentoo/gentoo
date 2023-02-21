# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-collections:commons-collections:3.2.2"

inherit java-pkg-2 java-ant-2 verify-sig

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="https://commons.apache.org/collections/"
SRC_URI="https://archive.apache.org/dist/commons/collections/source/commons-collections-${PV}-src.tar.gz
	verify-sig? ( https://archive.apache.org/dist/commons/collections/source/commons-collections-${PV}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos"
RESTRICT="!test? ( test )"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/${P}-fixes.patch"
)

src_prepare() {
	default
}

src_compile() {
	local antflags
	if use test; then
		antflags="tf.jar -Djunit.jar=$(java-pkg_getjars --build-only junit)"
	fi
	eant jar $(use_doc) ${antflags}
}

src_test() {
	if [[ "${ARCH}" = "ppc" ]]; then
		einfo "tests are disabled on ppc"
	else
		ANT_TASKS="ant-junit" eant testjar -Djunit.jar="$(java-pkg_getjars junit)"
	fi
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	use test && \
		java-pkg_newjar build/${PN}-testframework-${PV}.jar \
			${PN}-testframework.jar

	java-pkg_dohtml *.html
	if use doc; then
		java-pkg_dojavadoc build/docs/apidocs
	fi
	use source && java-pkg_dosrc src/java/*
}
