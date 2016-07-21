# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
WANT_AUTOMAKE="1.9"

inherit eutils autotools base java-pkg-2

DESCRIPTION="Java Interface to Tobias Oetiker's RRDtool"

SRC_URI="mirror://sourceforge/opennms/${P}.tar.gz"
HOMEPAGE="http://www.opennms.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"

SLOT="0"

COMMON_DEP="net-analyzer/rrdtool"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

PATCHES=( "${FILESDIR}/1.0.1-javacflags.patch" )

src_unpack() {
	base_src_unpack
	cd "${S}"
	# Running autoconf would require some RPM macros
	eautomake
}

src_compile(){
	base_src_compile
	if use doc; then
		javadoc -d javadoc $(find org -name "*.java") || die "javadoc failed"
	fi
}

src_install() {
	java-pkg_newjar "${S}/${PN}.jar"
	java-pkg_doso .libs/*.so
	use source && java-pkg_dosrc org
	use doc && java-pkg_dojavadoc javadoc
}
