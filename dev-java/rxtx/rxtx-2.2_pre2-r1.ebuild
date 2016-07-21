# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit toolchain-funcs versionator autotools java-pkg-2

MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Native lib providing serial and parallel communication for Java"
HOMEPAGE="http://rxtx.qbang.org/"
SRC_URI="ftp://ftp.qbang.org/pub/rxtx/${MY_P}.zip"
LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="lfd"

RDEPEND=">=virtual/jre-1.6
	lfd? ( sys-apps/xinetd )"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "s:\(\$(JAVADOC)\):\1 -d api:g" Makefile.am || die
	sed -i \
		-e "s:UTS_RELEASE::g" \
		-e "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" \
		-e "s:-source ... -target ...:$(java-pkg_javac-args):g" \
		configure.in || die

	epatch \
		"${FILESDIR}/${PN}-2.1-7r2-lfd.diff" \
		"${FILESDIR}/${PN}-2.1-7r2-nouts.diff" \
		"${FILESDIR}/${P}-add-ttyACM.patch" \
		"${FILESDIR}/${P}-limits.patch"

	rm acinclude.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable lfd lockfile_server)
}

src_compile() {
	emake

	if use lfd ; then
		# see INSTALL in src/ldf
		$(tc-getCC) ${LDFLAGS} ${CFLAGS} src/lfd/lockdaemon.c -o src/lfd/in.lfd || die
	fi

	if use doc ; then
		emake docs
	fi

	# Fix for src zip creation
	if use source ; then
		mkdir -p src_with_pkg/gnu || die
		ln -s ../../src src_with_pkg/gnu/io || die
	fi
}

src_install() {
	java-pkg_dojar RXTXcomm.jar
	java-pkg_doso ${CHOST}/.libs/*.so

	dodoc AUTHORS ChangeLog INSTALL PORTING TODO SerialPortInstructions.txt
	docinto html
	dodoc RMISecurityManager.html

	if use lfd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/lockfiled.xinetd" lfd
		dosbin src/lfd/in.lfd
		dodoc src/lfd/LockFileServer.rfc
	fi

	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc src_with_pkg/gnu
}

pkg_postinst() {
	if use lfd ; then
		elog "Don't forget to enable the LockFileServer"
		elog "daemon (lfd) in /etc/xinetd.d/lfd"
	else
		elog "RXTX uses UUCP style device-locks. You should"
		elog "add every user who needs to access serial ports"
		elog "to the 'uucp' group:"
		elog
		elog "    usermod -aG uucp <user>"
	fi
}
