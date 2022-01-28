# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit python-any-r1 systemd tmpfiles

MY_PV="${PV/_p/-P}"
MY_PV="${MY_PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

RRL_PV="${MY_PV}"

DESCRIPTION="Berkeley Internet Name Domain - Name Server"
HOMEPAGE="https://www.isc.org/software/bind"
SRC_URI="https://downloads.isc.org/isc/bind9/${PV}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux"
IUSE="+caps dnsrps dnstap doc doh fixed-rrset idn geoip gssapi lmdb selinux static-libs test-extra xml"

DEPEND="
	acct-group/named
	acct-user/named
	dev-libs/jemalloc
	dev-libs/json-c:=
	dev-libs/libuv:=
	sys-libs/zlib
	dev-libs/openssl:=[-bindist(-)]
	caps? ( >=sys-libs/libcap-2.1.0 )
	dnstap? ( dev-libs/fstrm dev-libs/protobuf-c )
	doh? ( net-libs/nghttp2 )
	geoip? ( dev-libs/libmaxminddb )
	gssapi? ( virtual/krb5 )
	idn? ( net-dns/libidn2 )
	lmdb? ( dev-db/lmdb )
	xml? ( dev-libs/libxml2 )
"
BDEPEND="
	test-extra? (
		${PYTHON_DEPS}
		dev-python/pytest
		dev-perl/Net-DNS-SEC
		dev-util/cmocka
	)
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-bind )
	sys-process/psmisc
	!net-dns/bind-tools
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myeconfargs=(
		--prefix="${EPREFIX}"/usr
		--sysconfdir=/etc/bind
		--localstatedir=/var
		--enable-full-report
		--without-readline
		--with-openssl="${ESYSROOT}"/usr
		--with-jemalloc
		--with-json-c
		--with-zlib
		$(use_enable caps linux-caps)
		$(use_enable dnsrps)
		$(use_enable dnstap)
		$(use_enable doh)
		$(use_with doh libnghttp2)
		$(use_enable fixed-rrset)
		$(use_enable static-libs static)
		$(use_enable geoip)
		$(use_with geoip maxminddb)
		$(use_with gssapi)
		$(use_with idn libidn2)
		$(use_with lmdb)
		$(use_with xml libxml2)
		"${@}"
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# "${WORKDIR}/${P}"/bin/tests/system/README
	# ifconfig.sh up and then down as root
	#default

	# just run the tests that dont mock around with IPs
	emake -C lib/ check
}

src_install() {
	default

	dodoc CHANGES README.md

	if use doc; then
		docinto misc
		dodoc -r doc/misc/

		docinto html
		dodoc -r doc/arm/

		docinto dnssec-guide
		dodoc -r doc/dnssec-guide/

		docinto contrib
		dodoc contrib/scripts/nanny.pl
	fi

	insinto /etc/bind
	newins "${FILESDIR}"/named.conf-r9 named.conf.auth

	newinitd "${FILESDIR}"/named.init-r15 named
	newconfd "${FILESDIR}"/named.confd-r8 named

	newenvd "${FILESDIR}"/10bind.env 10bind

	use static-libs || find "${ED}"/usr/lib* -name '*.la' -delete

	dosym ../../var/bind/pri /etc/bind/pri
	dosym ../../var/bind/sec /etc/bind/sec
	dosym ../../var/bind/dyn /etc/bind/dyn
	keepdir /var/bind/{pri,sec,dyn} /var/log/named

	fowners root:named /{etc,var}/bind /var/log/named /var/bind/{sec,pri,dyn}
	fowners root:named /etc/bind/{bind.keys,named.conf.auth}
	fperms 0640 /etc/bind/{bind.keys,named.conf.auth}
	fperms 0750 /etc/bind /var/bind/pri
	fperms 0770 /var/log/named /var/bind/{,sec,dyn}

	systemd_newunit "${FILESDIR}/named.service-r1" named.service
	dotmpfiles "${FILESDIR}"/named.conf
	exeinto /usr/libexec
	doexe "${FILESDIR}/generate-rndc-key.sh"
}

pkg_postinst() {
	tmpfiles_process named.conf

	if [[ ! -f '/etc/bind/rndc.key' && ! -f '/etc/bind/rndc.conf' ]]; then
		einfo "Using /dev/urandom for generating rndc.key"
		/usr/sbin/rndc-confgen -a
		chown root:named /etc/bind/rndc.key || die
		chmod 0640 /etc/bind/rndc.key || die
	fi
}
