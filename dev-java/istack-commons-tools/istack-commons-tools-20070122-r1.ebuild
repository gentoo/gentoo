# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="istack-commons - tools"
HOMEPAGE="https://istack-commons.dev.java.net/"
SRC_URI="mirror://gentoo/istack-commons-${PV}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/istack-commons-${PV}"

src_unpack() {
	unpack ${A}

	java-ant_bsfix_one "${S}/build-common.xml"

	cd "${S}/tools"
	mkdir -p lib || die

	ln -s $(java-config --tools) lib || die
}

EANT_BUILD_XML="tools/build.xml"

src_install() {

	java-pkg_dojar tools/build/istack-commons-tools.jar

	use source && java-pkg_dosrc tools/src/*

}
