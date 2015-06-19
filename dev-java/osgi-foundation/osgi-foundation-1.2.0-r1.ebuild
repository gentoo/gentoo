# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/osgi-foundation/osgi-foundation-1.2.0-r1.ebuild,v 1.1 2013/07/18 08:12:12 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="OSGi R4 Foundation EE by Apache Felix"
HOMEPAGE="http://felix.apache.org/"
SRC_URI="http://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml "${S}"/build.xml || die
}

src_install() {
	java-pkg_newjar target/org.osgi.foundation-${PV}.jar org.osgi.foundation.jar
}
