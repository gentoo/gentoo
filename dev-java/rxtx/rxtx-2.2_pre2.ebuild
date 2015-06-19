# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/rxtx/rxtx-2.2_pre2.ebuild,v 1.4 2015/05/27 11:29:46 ago Exp $

EAPI="4"

inherit toolchain-funcs versionator autotools java-pkg-2

MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Native lib providing serial and parallel communication for Java"
HOMEPAGE="http://rxtx.qbang.org/"
SRC_URI="ftp://ftp.qbang.org/pub/rxtx/${MY_P}.zip"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE="doc source lfd"

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core
	lfd? ( sys-apps/xinetd )
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# some minor fixes
	sed -i -e "s:UTS_RELEASE::g" configure.in || die
	sed -i -e "s:|1.5\*:|1.5*|1.6*|1.7*:g" configure.in || die
	sed -i -e "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" configure.in || die
	sed -i -e "s:\(\$(JAVADOC)\):\1 -d api:g" Makefile.am || die

	# some patches
	epatch "${FILESDIR}/${PN}-2.1-7r2-lfd.diff"
	epatch "${FILESDIR}/${PN}-2.1-7r2-nouts.diff"
	epatch "${FILESDIR}/${P}-add-ttyACM.patch"

	# update autotools stuff
	rm acinclude.m4
	eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable lfd lockfile_server)
}

src_compile() {
	emake

	if use lfd ; then
		# see INSTALL in src/ldf
		$(tc-getCC) ${LDFLAGS} ${CFLAGS} src/lfd/lockdaemon.c -o src/lfd/in.lfd || die "compiling lfd failed"
	fi

	if use doc ; then
		emake docs
	fi

	#Fix for src zip creation
	if use source ; then
		mkdir -p src_with_pkg/gnu
		ln -s ../../src src_with_pkg/gnu/io
	fi
}

src_install() {
	java-pkg_dojar RXTXcomm.jar
	java-pkg_doso ${CHOST}/.libs/*.so

	dodoc AUTHORS ChangeLog INSTALL PORTING TODO SerialPortInstructions.txt
	dohtml RMISecurityManager.html

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
