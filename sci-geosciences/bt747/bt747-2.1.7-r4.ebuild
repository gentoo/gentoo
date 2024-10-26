# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

DESCRIPTION="MTK GPS Datalogger Device Control"
HOMEPAGE="https://www.bt747.org"
SRC_URI="https://downloads.sourceforge.net/project/bt747/Development/BT747_${PV}_full.zip
	https://www.bt747.org/icon/bt747_128x128.gif -> ${PN}.gif"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="1"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip:0
	>=dev-java/ant-1.10.14-r3:0"
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

# Java 11 because of compile error with 1.8
# /var/tmp/portage/sci-geosciences/bt747-2.1.7-r3/work/build.xml:1478:
# java.lang.NoSuchMethodError: java.nio.CharBuffer.flip()Ljava/nio/CharBuffer;
DEPEND="${CDEPEND}
	>=virtual/jdk-11:*
"
RDEPEND="${CDEPEND}
	dev-libs/glib:2[dbus]
	>=virtual/jre-1.8:*
"

DOCS=( ChangeLog.txt )
PATCHES=(
	"${FILESDIR}/bt747-2.1.7-source-target.patch"
	# Fix for newer jchart2d.
	"${FILESDIR}/jchart2d-3.2.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	# Remove all the bundled stuff.
	rm -rv dist/ lib/ || die

	# GraphicsUtilities moved in later SwingX versions.
	sed -i "s:org\.jdesktop\.swingx\.graphics\.GraphicsUtilities:org.jdesktop.swingx.util.GraphicsUtilities:g" \
		src_j2se/net/sf/bt747/j2se/app/list/FileListCellRenderer.java || die

	# EANT_EXTRA_ARGS="-Dskip.proguard=yes -Dsvn=true -Dsvnversion=true -Dbuild.current.revision=Gentoo"
	cat > build.properties <<-EOF || die
		skip.proguard=yes
		svn=true
		svnversion=true
		build.current.revision=Gentoo
		ant.build.javac.source=$(java-pkg_get-source)
		ant.build.javac.target=$(java-pkg_get-target)
		jcalendar.jar=$(java-pkg_getjars jcalendar-1.2)
		jchart.jar=$(java-pkg_getjars jchart2d)
		jopt-simple.jar=$(java-pkg_getjars jopt-simple)
		rxtxcomm.jar=$(java-pkg_getjars rxtx-2)
		sanselan.jar=$(java-pkg_getjars commons-imaging)
		swing-layout.jar=$(java-pkg_getjars swing-layout-1)
		swingx.jar=$(java-pkg_getjars swingx-1.6)
		swingx-ws.jar=$(java-pkg_getjars swingx-ws-bt747)
	EOF
}

src_compile() {
	eant dist.j2se
}

src_install() {
	java-pkg_dojar dist/*.jar
	java-pkg_dolauncher ${PN} --main bt747.j2se_view.BT747Main \
		--java-args="-Xmx192m"

	doicon "${DISTDIR}/${PN}.gif"
	make_desktop_entry ${PN} BT747 bt747.gif
}
