# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libg/libg-2.1.0-r1.ebuild,v 1.3 2015/04/02 18:32:12 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Lots of small utilities for bndlib, a swiss army knife for OSGi"
HOMEPAGE="http://www.aqute.biz/Bnd/Bnd"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.REL.tar.gz -> bndlib-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Tests depend on biz.aQute.junit, which depends on biz.aQute.bndlib, which on
# its own turn again depends on aQute.libg again; we can temporarily assume that
# if bndlib tests pass that libg is sufficiently tested, in the future we should
# look whether it is feasible to combine the packages or otherwise temporarily
# build biz.aquite.bndlib and biz.aqute.junit in this package.
RESTRICT="test"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/bnd-${PV}.REL/aQute.${PN}"

EANT_BUILD_TARGET="build"

java_prepare() {
	# Move the correct build.xml into place, needed for testing.
	cp ../cnf/build.xml . || die "Failed to move build file into the right place."

	# Remove bundled jar files.
	find . -name '*.jar' -delete

	# Remove test files
	if ! use test ; then
		find src/test -name '*.java' -delete || die "Failed to remove test files."
	fi
}

src_install() {
	java-pkg_newjar generated/aQute.${PN}.jar
}
