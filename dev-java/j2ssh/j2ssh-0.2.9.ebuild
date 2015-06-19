# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/j2ssh/j2ssh-0.2.9.ebuild,v 1.1 2013/10/08 16:37:35 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="source doc examples"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java implementation of the SSH protocol"
HOMEPAGE="http://sourceforge.net/projects/sshtools/ http://www.sshtools.com/"
SRC_URI="mirror://sourceforge/sshtools/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/commons-logging:0
	dev-java/ant-core:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="build"
EANT_GENTOO_CLASSPATH="commons-logging,ant-core"

src_prepare() {
	epatch "${FILESDIR}/${PV}-no-versioned-jars.patch"
	epatch "${FILESDIR}/${PV}-extras.patch"
}

src_install() {
	java-pkg_dojar "${S}"/dist/lib/*.jar

	use doc && java-pkg_dojavadoc docs/
	use source && java-pkg_dosrc "${S}"/src/com
	use examples && java-pkg_doexamples "${S}"/examples/
}
