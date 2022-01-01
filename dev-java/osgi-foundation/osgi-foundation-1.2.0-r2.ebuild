# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="OSGi R4 Foundation EE by Apache Felix"
HOMEPAGE="http://felix.apache.org/"
SRC_URI="https://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="Apache-2.0 OSGi-Specification-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_prepare() {
	default
	cp "${FILESDIR}"/${P}-build.xml "${S}"/build.xml || die
}

src_install() {
	java-pkg_newjar target/org.osgi.foundation-${PV}.jar org.osgi.foundation.jar
}
