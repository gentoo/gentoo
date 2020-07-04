# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE=source
inherit desktop eutils java-pkg-2 java-ant-2 xdg

DESCRIPTION="Editor for VDR channels.conf"
HOMEPAGE="https://sites.google.com/site/reniershomepage/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

PATCHES=(
	# include localisation changes
	"${FILESDIR}"/${P}-messages.properties.patch
	"${FILESDIR}"/${P}-messages_en.properties.patch
)

S="${WORKDIR}/${PN}"

mainclass() {
	# read Main-Class from MANIFEST.MF
	sed -n "s/^Main-Class: \([^ ]\+\).*/\1/p" "${S}/MANIFEST.MF" \
	|| die "reading Main-Class failed"
}

src_prepare() {
	default

	xdg_environment_reset

	# move files out of build and remove stuff not needed in the package
	mv build/* "${S}" || die "cleaning build dir failed"
	rm -f src/java/org/javalobby/icons/{README,COPYRIGHT} \
		|| die "removing files failed"

	# copy build.xml
	cp -f "${FILESDIR}/build-${PV}.xml" build.xml \
		|| die "copying build.xml failed"

	# convert CRLF to LF
	edos2unix MANIFEST.MF
}

src_compile() {
	eant build -Dmanifest.mainclass=$(mainclass)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher ${PN} --main $(mainclass)

	use source && java-pkg_dosrc src

	make_desktop_entry channeleditor Channeleditor "" "Utility"
}
