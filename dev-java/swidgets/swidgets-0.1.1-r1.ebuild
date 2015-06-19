# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/swidgets/swidgets-0.1.1-r1.ebuild,v 1.9 2015/03/21 10:43:57 jlec Exp $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Various reusable SWING components"
HOMEPAGE="http://swidgets.tigris.org"
SRC_URI="http://swidgets.tigris.org/files/documents/1472/18566/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.3
		dev-java/toolbar"

DEPEND="${RDEPEND}
		>=virtual/jdk-1.3
		app-arch/unzip"

src_unpack() {
	unpack ${A}

	# Remove the CVS directories
	ecvs_clean

	# Create the directory structor
	mkdir "${S}"

	# Move the broken out source file
	mv src "${S}"
	mv LabelledLayout.java "${S}"/src/org/tigris/swidgets/

	# Copy the build.xml
	cp "${FILESDIR}"/build.xml "${S}" || die "Unable to copy the build file!"

	cat > "${S}"/build.properties <<- EOF
		src=src
		dest=dest
		build=build
		version=${PV}
		classpath=$(java-config -p toolbar)
	EOF
}

src_install() {
	java-pkg_newjar dest/swidgets-${PV}.jar ${PN}.jar
	use source && java-pkg_dosrc "${S}"/src/org/
}
