# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit toolchain-funcs autotools java-pkg-2

MY_PV="$(ver_rs 2 '')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Native library providing serial and parallel communication for Java"
# SSL protocol versions supported by the HTTPS website are too old for
# the latest web browsers, so please keep the HTTP URL for HOMEPAGE
HOMEPAGE="http://rxtx.qbang.org/"
SRC_URI="ftp://ftp.qbang.org/pub/rxtx/${MY_P}.zip"
LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="lfd"

RDEPEND=">=virtual/jre-1.8:*
	lfd? ( sys-apps/xinetd )"

DEPEND=">=virtual/jdk-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "s:\(\$(JAVADOC)\):\1 -d api:g" Makefile.am || die
	sed -i \
		-e "s:UTS_RELEASE::g" \
		-e "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" \
		-e "s:-source ... -target ...:$(java-pkg_javac-args):g" \
		configure.in || die

	eapply -p0 "${FILESDIR}/${PN}-2.1-7r2-lfd.diff"
	eapply -p0 "${FILESDIR}/${PN}-2.1-7r2-nouts.diff"
	eapply "${FILESDIR}/${PN}-2.1-7r2-ppcioh.diff"
	eapply "${FILESDIR}/${PN}-2.1-7r2-ttyPZ.diff"
	eapply -p0 "${FILESDIR}/${P}-limits.patch"
	eapply "${FILESDIR}/${P}-add-ttyACM.patch"
	eapply "${FILESDIR}/${P}-format-security.patch"
	eapply "${FILESDIR}/${P}-fix-invalid-javadoc.patch"
	eapply "${FILESDIR}/${P}-fix-for-java-10+.patch"
	eapply_user

	rm acinclude.m4 || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable lfd lockfile_server)
}

src_compile() {
	# Parallel build on this package may cause random
	# build-time errors sometimes due to race conditions
	emake -j1

	if use lfd ; then
		# see INSTALL in src/ldf
		$(tc-getCC) ${LDFLAGS} ${CFLAGS} src/lfd/lockdaemon.c -o src/lfd/in.lfd || die
	fi

	if use doc ; then
		emake -j1 docs
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
