# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 java-ant-2

DESCRIPTION="MTK GPS Datalogger Device Control"
HOMEPAGE="https://www.bt747.org"
SRC_URI="https://downloads.sourceforge.net/project/bt747/Development/BT747_${PV}_full.zip
	https://www.bt747.org/icon/bt747_128x128.gif -> ${PN}.gif"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip:0"
CDEPEND="
	dev-java/commons-imaging:0
	dev-java/jcalendar:1.2
	dev-java/jchart2d:0
	dev-java/jopt-simple:0
	>=dev-java/rxtx-2.2_pre2:2
	dev-java/swing-layout:1
	dev-java/swingx:1.6
	dev-java/swingx-ws:bt747
"
RDEPEND="${CDEPEND}
	dev-libs/glib:2[dbus]
	>=virtual/jre-1.8:*
"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
"

EANT_BUILD_TARGET="dist.j2se"
EANT_EXTRA_ARGS="-Dskip.proguard=yes -Dsvn=true -Dsvnversion=true -Dbuild.current.revision=Gentoo"
EANT_GENTOO_CLASSPATH="commons-imaging,jcalendar-1.2,jchart2d,jopt-simple,rxtx-2,swing-layout-1,swingx-1.6,swingx-ws-bt747"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	java-pkg-2_src_prepare
	# Fix for newer jchart2d.
	eapply "${FILESDIR}/jchart2d-3.2.patch"

	# Remove all the bundled stuff.
	rm -rv dist/ lib/ || die

	# GraphicsUtilities moved in later SwingX versions.
	sed -i "s:org\.jdesktop\.swingx\.graphics\.GraphicsUtilities:org.jdesktop.swingx.util.GraphicsUtilities:g" \
		src_j2se/net/sf/bt747/j2se/app/list/FileListCellRenderer.java || die
}

src_install() {
	dodoc {ChangeLog,README}.txt

	java-pkg_dojar dist/*.jar
	java-pkg_dolauncher ${PN} --main bt747.j2se_view.BT747Main \
		--java-args="-Xmx192m"

	doicon "${DISTDIR}/${PN}.gif"
	make_desktop_entry ${PN} BT747 bt747.gif
}
