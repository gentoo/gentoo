# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ssl-cert systemd tmpfiles

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="https://www.stunnel.org/index.html"
SRC_URI="
	https://www.stunnel.org/downloads/${P}.tar.gz
	ftp://ftp.stunnel.org/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://www.usenix.org.uk/mirrors/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://ftp.nluug.nl/pub/networking/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://www.namesdir.com/mirrors/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	http://stunnel.cybermirror.org/archive/${PV%%.*}.x/${P}.tar.gz
	http://mirrors.zerg.biz/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
	ftp://mirrors.go-parts.com/stunnel/archive/${PV%%.*}.x/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="selinux stunnel3 tcpd"

DEPEND="
	dev-libs/openssl:0=
	tcpd? ( sys-apps/tcp-wrappers )
"

RDEPEND="
	acct-user/stunnel
	acct-group/stunnel
	${DEPEND}
	selinux? ( sec-policy/selinux-stunnel )
	stunnel3? ( dev-lang/perl )
"

RESTRICT="test"

src_prepare() {
	# Hack away generation of certificate
	sed -i -e "s/^install-data-local:/do-not-run-this:/" \
		tools/Makefile.in || die "sed failed"

	echo "CONFIG_PROTECT=\"/etc/stunnel/stunnel.conf\"" > "${T}"/20stunnel

	eapply_user
}

src_configure() {
	local myeconfargs=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable tcpd libwrap)
		--with-ssl="${EPREFIX}"/usr
		--disable-fips
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${ED}"/usr/share/doc/${PN}
	rm -f "${ED}"/etc/stunnel/stunnel.conf-sample \
		"${ED}"/usr/share/man/man8/stunnel.{fr,pl}.8
	use stunnel3 || rm -f "${ED}"/usr/bin/stunnel3

	dodoc AUTHORS.md BUGS.md CREDITS.md PORTS.md README.md TODO.md
	docinto html
	dodoc doc/stunnel.html doc/en/VNC_StunnelHOWTO.html tools/ca.html \
		tools/importCA.html

	insinto /etc/stunnel
	doins "${FILESDIR}"/stunnel.conf
	newinitd "${FILESDIR}"/stunnel-r2 stunnel

	doenvd "${T}"/20stunnel

	systemd_dounit "${S}/tools/stunnel.service"
	newtmpfiles "${FILESDIR}"/stunnel.tmpfiles.conf stunnel.conf

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [ ! -f "${EROOT}"/etc/stunnel/stunnel.key ]; then
		install_cert /etc/stunnel/stunnel
		chown stunnel:stunnel "${EROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
		chmod 0640 "${EROOT}"/etc/stunnel/stunnel.{crt,csr,key,pem}
	fi

	tmpfiles_process stunnel.conf

	einfo "If you want to run multiple instances of stunnel, create a new config"
	einfo "file ending with .conf in /etc/stunnel/. **Make sure** you change "
	einfo "\'pid= \' with a unique filename.  For openrc make a symlink from the"
	einfo "stunnel init script to \'stunnel.name\' and use that to start|stop"
	einfo "your custom instance"
}
