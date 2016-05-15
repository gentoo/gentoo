# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 versionator

DESCRIPTION="A desktop client for Mozilla's Bugzilla bug tracking system"
HOMEPAGE="http://almworks.com/deskzilla"

MY_PV=$(replace_all_version_separators '_') #${PV/beta/b})
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="http://d1.almworks.com/.files/${MY_P}_without_jre.tar.gz
		https://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/deskzilla_gentoo.license"
LICENSE="ALMWorks-1.2"
# license does not allow redistributing, and they seem to silently update
# distfiles...
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5
	dev-java/picocontainer:1
	dev-java/javolution:4
	>=dev-java/commons-codec-1.3
	>=dev-java/jgoodies-forms-1.0.7
	>=dev-java/commons-logging-1.0.4
	>=dev-java/xmlrpc-2.0.1
	dev-java/xerces:2
	dev-java/itext:0
	dev-java/jazzy:0"

src_unpack() {
	unpack ${A}
	# Remove external unaltered bundled jars
	local lib="${S}/lib"
	local liborig="${S}/lib.orig"
	mv ${lib} ${liborig} || die
	mkdir ${lib} || die
	# They've patched commons-httpclient (was version 3.0)
	mv ${liborig}/commons-httpclient.jar ${lib} || die
	# They've patched nekohtml (was version 0.9.5)
	mv ${liborig}/nekohtml.jar ${lib} || die
	# Also jdom (was 1.0), soon they will patch everything and we will just unpack, yay
	mv ${liborig}/pjdom.jar ${lib} || die
	# Almworks proprietary lib
	mv ${liborig}/almworks-tracker-api.jar ${lib} || die
	# IntelliJ IDEA proprietary lib
	mv ${liborig}/forms_rt.jar ${lib} || die
	# God knows what's this. Anyway, proprietary.
	mv ${liborig}/twocents.jar ${lib} || die
	rm -rf ${liborig} || die
}

src_install () {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r components etc license lib log deskzilla.url
	insinto "${dir}/license"
	doins "${DISTDIR}"/deskzilla_gentoo.license

	java-pkg_jarinto "${dir}"
	java-pkg_dojar ${PN}.jar
	local dep="xerces-2,picocontainer-1,commons-logging,commons-codec"
	dep+=",jgoodies-forms,javolution-4,xmlrpc,itext,jazzy"
	java-pkg_register-dependency ${dep}
	java-pkg_dolauncher ${PN} --main "com.almworks.launcher.Launcher" --java_args "-Xmx256M"

	newdoc README.txt README || die
	newdoc RELEASE.txt RELEASE || die

	doicon deskzilla.png
	make_desktop_entry deskzilla "Deskzilla" deskzilla "Development"
}

pkg_postinst() {
	elog "The default, evaluation license allows usage for one month."
	elog "You may switch (per-user) to the license we obtained for Gentoo,"
	elog "located in /opt/${PN}/license/${PN}_gentoo.license"
	elog "It is locked to Gentoo, ALM Works and Mozilla bugzilla only."
	elog "Note that you need to use 1.5 VM to run deskzilla when setting"
	elog "license or it won't get set due to bug in 1.6+ VMs."
	elog
	elog "If you are going to use Deskzilla for an open source project,"
	elog "you can similarly request your own free license:"
	elog "http://almworks.com/opensource.html?product=deskzilla"
}
