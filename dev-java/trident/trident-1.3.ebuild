# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java animation library"
HOMEPAGE="https://kenai.com/projects/trident/pages/Home"
SRC_URI="https://kenai.com/projects/trident/downloads/download/version%20${PV}%20-%20stable/${PN}-all.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

COMMON_DEPEND="dev-java/swt:3.7"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPEND}"

S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="timestamp init clean compile.module.trident jar"
EANT_GENTOO_CLASSPATH="swt-3.7"
EANT_EXTRA_ARGS="-Djdk.home=${JAVA_HOME}"

java_prepare() {
	mkdir build/classes -p || die
	rm -r src/org/pushingpixels/trident/android/ || die
	epatch "${FILESDIR}"/${PV}-*.patch
}

src_install() {
	java-pkg_dojar drop/${PN}.jar

	use source && java-pkg_dosrc src/*
}
