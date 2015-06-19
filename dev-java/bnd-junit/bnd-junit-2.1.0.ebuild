# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bnd-junit/bnd-junit-2.1.0.ebuild,v 1.4 2015/06/07 08:30:27 jlec Exp $

EAPI="5"

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Junit plugin for bndlib, a swiss army knife for OSGi"
HOMEPAGE="http://www.aqute.biz/Bnd/Bnd"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.REL.tar.gz -> bndlib-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/osgi-core-api:0
	dev-java/bndlib:0"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:4 )
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

S="${WORKDIR}/bnd-${PV}.REL/biz.aQute.junit"

EANT_BUILD_TARGET="build"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bndlib,junit-4,osgi-core-api"

# Tests appear broken and cause a circular dependency.
RESTRICT="test"

java_prepare() {
	# Move the correct build.xml into place, needed for testing.
	cp ../cnf/build.xml . || die

	# Remove bundled jar files.
	find . -name '*.jar' -delete > /dev/null
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar generated/biz.aQute.junit.jar
}
