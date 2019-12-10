# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 java-utils-2

DESCRIPTION="Jakarta-Commons Collections Component"
HOMEPAGE="https://commons.apache.org/collections/"
SRC_URI="mirror://apache/${PN/-//}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	>=virtual/jdk-1.6"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${P}-src"

PATCHES=( "${FILESDIR}/${P}-Java-8.patch" )

src_prepare() {
	default
}

src_compile() {
	local antflags
	if use test; then
		antflags="tf.jar -Djunit.jar=$(java-pkg_getjars junit)"
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
