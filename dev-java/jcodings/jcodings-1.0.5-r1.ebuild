# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Byte-based encoding support library for Java"
HOMEPAGE="https://github.com/codehaus"
SRC_URI="https://github.com/jruby/${PN}/archive/${PV}.tar.gz -> ${P}-git.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

src_unpack() {
	default
	mv jruby-${PN}-* ${P} || die
}

src_prepare() {
	default
	cp "${FILESDIR}"/maven-build.xml build.xml || die
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/*
}
