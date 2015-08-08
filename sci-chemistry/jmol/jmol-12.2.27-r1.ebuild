# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WEBAPP_OPTIONAL="yes"

inherit eutils webapp java-pkg-2 java-ant-2

MY_P=Jmol

DESCRIPTION="Java molecular viever for 3-D chemical structures"
HOMEPAGE="http://jmol.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${MY_P}-${PV}-full.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PN}-selfSignedCertificate.store.tar"

LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE="+client-only vhosts"

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

COMMON_DEP="
	dev-java/commons-cli:1
	dev-java/itext:0
	sci-libs/jmol-acme:0
	sci-libs/vecmath-objectclub:0
	sci-libs/naga"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	dev-java/saxon:6.5
	!client-only? ( ${WEBAPP_DEPEND} )
	${COMMON_DEP}"

pkg_setup() {
	use client-only || webapp_pkg_setup
	java-pkg-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nointl.patch

	rm -v "${S}"/*.jar "${S}"/plugin-jars/*.jar || die
	cd "${S}/jars"

# We still have to use netscape.jar on amd64 until a nice way to include plugin.jar comes along.
	if use amd64; then
		mv -v netscape.jar netscape.tempjar || die "Failed to move netscape.jar."
		rm -v *.jar *.tar.gz || die "Failed to remove jars."
		mv -v netscape.tempjar netscape.jar || die "Failed to move netscape.tempjar."
	fi

	java-pkg_jar-from vecmath-objectclub vecmath-objectclub.jar vecmath1.2-1.14.jar
	java-pkg_jar-from itext iText.jar itext-1.4.5.jar
	java-pkg_jar-from jmol-acme jmol-acme.jar Acme.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar commons-cli-1.0.jar
	java-pkg_jar-from naga
	java-pkg_jar-from --build-only saxon-6.5 saxon.jar

	mkdir -p "${S}/build/appjars" || die
}

src_compile() {
	# prevent absorbing dep's classes
	eant -Dlibjars.uptodate=true main
}

src_install() {
	java-pkg_dojar build/Jmol.jar
	dohtml -r  build/doc/* || die "Failed to install html docs."
	dodoc *.txt doc/*license* || die "Failed to install licenses."

	java-pkg_dolauncher ${PN} --main org.openscience.jmol.app.Jmol \
		--java_args "-Xmx512m"

	if ! use client-only ; then
		webapp_src_preinst
		cp Jmol.js build/Jmol.jar "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp build/JmolApplet*.jar "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp applet.classes "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp -r build/classes/* "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp -r build/appletjars/* "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp "${FILESDIR}"/caffeine.xyz "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."
		cp "${FILESDIR}"/index.html "${ED}"${MY_HTDOCSDIR} || die "${cmd} failed."

		webapp_src_install
	fi
}

pkg_postinst() {
	use client-only || webapp_pkg_postinst
}

pkg_prerm() {
	use client-only || webapp_pkg_prerm
}
