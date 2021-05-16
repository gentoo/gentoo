# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Byte-based encoding support library for Java"
HOMEPAGE="https://github.com/codehaus"
SRC_URI="https://github.com/jruby/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
		>=dev-java/junit-4.8:4
	)"

S="${WORKDIR}/${PN}-${PN}-${PV}"

src_prepare() {
	default
	cp "${FILESDIR}"/maven-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/*
}
