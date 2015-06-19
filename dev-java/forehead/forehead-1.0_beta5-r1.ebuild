# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/forehead/forehead-1.0_beta5-r1.ebuild,v 1.3 2010/05/22 20:05:56 ken69267 Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="A framework to assist in controlling the run-time ClassLoader"
HOMEPAGE="http://forehead.werken.com"
SRC_URI="mirror://gentoo/forehead-${PV}.tbz2"

LICENSE="Werken-1.1.1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.3
		dev-java/ant-core"
RDEPEND=">=virtual/jre-1.3"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}

	# Copy over the new build.xml
	cp "${FILESDIR}"/build.xml "${S}" || die
}

src_compile() {
	eant jar -Dversion=${PV} $(use_doc)
}

src_install() {
	java-pkg_newjar "${S}"/dest/forehead-${PV}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/{java,misc}
}
