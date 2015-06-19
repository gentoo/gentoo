# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/toolbar/toolbar-1.1.0-r1.ebuild,v 1.8 2015/03/21 11:48:24 jlec Exp $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An improved version of JToolBar"
HOMEPAGE="http://toolbar.tigris.org"
SRC_URI="http://toolbar.tigris.org/files/documents/869/25285/toolbar-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}

	# Remove the CVS directories
	ecvs_clean

	# Make the work environment
	mkdir "${S}"

	# Setup the structure
	mv src "${S}"
	rm -rf test

	# Copy over the build.xml
	cp "${FILESDIR}"/build.xml "${S}" || die "Unable to copy the build file!"

	cat > "${S}/build.properties" <<- EOF
		src=src
		dest=dest
		build=build
		version=${PV}
	EOF
}

src_compile() {
	eant -Dversion=${PV}
}

src_install() {
	java-pkg_newjar dest/toolbar-${PV}.jar ${PN}.jar
	use source && java-pkg_dosrc "${S}"/src/org/
}
