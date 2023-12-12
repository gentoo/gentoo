# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit autotools python-any-r1 ssl-cert systemd tmpfiles

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
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="selinux stunnel3 systemd tcpd test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/openssl:=
	tcpd? ( sys-apps/tcp-wrappers )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
	acct-user/stunnel
	acct-group/stunnel
	selinux? ( sec-policy/selinux-stunnel )
	stunnel3? ( dev-lang/perl )
"
# autoconf-archive for F_S patch
BDEPEND="
	sys-devel/autoconf-archive
	test? ( ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.71-dont-clobber-fortify-source.patch
	"${FILESDIR}"/${PN}-5.71-respect-EPYTHON-for-tests.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Hack away generation of certificate
	sed -i -e "s/^install-data-local:/do-not-run-this:/" \
		tools/Makefile.am || die "sed failed"

	echo "CONFIG_PROTECT=\"/etc/stunnel/stunnel.conf\"" > "${T}"/20stunnel || die

	# We pass --disable-fips to configure, so avoid spurious test failures
	rm tests/plugins/p10_fips.py tests/plugins/p11_fips_cipher.py || die

	# Needed for FORTIFY_SOURCE patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--with-ssl="${EPREFIX}"/usr
		--disable-fips
		$(use_enable tcpd libwrap)
		$(use_enable systemd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rf "${ED}"/usr/share/doc/${PN} || die
	rm -f "${ED}"/etc/stunnel/stunnel.conf-sample \
		"${ED}"/usr/share/man/man8/stunnel.{fr,pl}.8 || die

	if ! use stunnel3 ; then
		rm -f "${ED}"/usr/bin/stunnel3 || die
	fi

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
	if [[ ! -f "${EROOT}"/etc/stunnel/stunnel.key ]]; then
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
