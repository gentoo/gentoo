# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit ssl-cert eutils multilib systemd user

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="http://www.stunnel.org/index.html"
SRC_URI="ftp://ftp.stunnel.org/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://www.usenix.org.uk/mirrors/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://ftp.nluug.nl/pub/networking/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://www.namesdir.com/mirrors/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://stunnel.cybermirror.org/archive/${PV%%.*}.x/${P}.tar.gz
	http://mirrors.zerg.biz/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	ftp://mirrors.go-parts.com/stunnel/archive/${PV%%.*}.x/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="ipv6 libressl selinux stunnel3 tcpd"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}
	stunnel3? ( dev-lang/perl )
	selinux? ( sec-policy/selinux-stunnel )"

RESTRICT="test"

pkg_setup() {
	enewgroup stunnel
	enewuser stunnel -1 -1 -1 stunnel
}

src_prepare() {
	# Hack away generation of certificate
	sed -i -e "s/^install-data-local:/do-not-run-this:/" \
		tools/Makefile.in || die "sed failed"

	# libressl compat
	epatch "${FILESDIR}"/stunnel-compat-libressl.patch

	echo "CONFIG_PROTECT=\"/etc/stunnel/stunnel.conf\"" > "${T}"/20stunnel
}

src_configure() {
	econf \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		$(use_enable ipv6) \
		$(use_enable tcpd libwrap) \
		--with-ssl="${EPREFIX}"/usr \
		--disable-fips
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${ED}"/usr/share/doc/${PN}
	rm -f "${ED}"/etc/stunnel/stunnel.conf-sample \
		"${ED}"/usr/share/man/man8/stunnel.{fr,pl}.8
	use stunnel3 || rm -f "${ED}"/usr/bin/stunnel3

	# The binary was moved to /usr/bin with 4.21,
	# symlink for backwards compatibility
	dosym ../bin/stunnel /usr/sbin/stunnel

	dodoc AUTHORS BUGS CREDITS PORTS README TODO ChangeLog
	dohtml doc/stunnel.html doc/en/VNC_StunnelHOWTO.html tools/ca.html \
		tools/importCA.html

	insinto /etc/stunnel
	doins "${FILESDIR}"/stunnel.conf
	newinitd "${FILESDIR}"/stunnel-r1 stunnel

	doenvd "${T}"/20stunnel

	systemd_dounit "${S}/tools/stunnel.service"
	systemd_newtmpfilesd "${FILESDIR}"/stunnel.tmpfiles.conf stunnel.conf
}

pkg_postinst() {
	if [ ! -f "${EROOT}"/etc/stunnel/stunnel.key ]; then
		install_cert /etc/stunnel/stunnel
		chown stunnel:stunnel "${EROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
		chmod 0640 "${EROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
	fi

	einfo "If you want to run multiple instances of stunnel, create a new config"
	einfo "file ending with .conf in /etc/stunnel/. **Make sure** you change "
	einfo "\'pid= \' with a unique filename."
}
