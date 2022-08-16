# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SSL_CERT_MANDATORY=1
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/unrealircd.asc
inherit autotools ssl-cert systemd tmpfiles verify-sig

DESCRIPTION="An advanced Internet Relay Chat daemon"
HOMEPAGE="https://www.unrealircd.org/"
SRC_URI="https://www.unrealircd.org/downloads/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://www.unrealircd.org/downloads/${P}.tar.gz.asc )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"
IUSE="class-nofakelag curl geoip +operoverride operoverride-verify"

RDEPEND="acct-group/unrealircd
	acct-user/unrealircd
	>=app-crypt/argon2-20171227-r1:=
	dev-libs/libpcre2
	dev-libs/libsodium:=
	dev-libs/openssl:=
	dev-libs/jansson:=
	>=net-dns/c-ares-1.7:=
	virtual/libcrypt:=
	curl? ( net-misc/curl[adns] )
	geoip? ( dev-libs/libmaxminddb )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-unrealircd )"

DOCS=( doc/{Authors,Donation,RELEASE-NOTES.md,tao.of.irc,technical/,translations.txt} )

src_prepare() {
	# QA check against bundled pkgs
	rm -r extras || die

	# building third-party modules (which we don't do) cause a sandbox violation
	# bug 704444
	echo "" > src/buildmod || die

	sed -e 's/$(MODULEFLAGS)/$(LDFLAGS) &/' -i src/modules/{,*/}Makefile.in || die

	if use class-nofakelag; then
		sed -i -e 's:^//#undef\( FAKELAG_CONFIGURABLE\):#define\1:' include/config.h || die
	fi

	# File is missing from the 5.0.9.1 tarball
	sed -i -e '/unrealircd-upgrade-script/d' configure.ac || die

	default
	eautoreconf
}

src_configure() {
	# Default value for privatelibdir adds a build path to -Wl,-rpath.
	econf \
		--with-bindir="${EPREFIX}"/usr/bin \
		--with-cachedir="${EPREFIX}"/var/lib/${PN} \
		--with-confdir="${EPREFIX}"/etc/${PN} \
		--with-datadir="${EPREFIX}"/var/lib/${PN} \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-logdir="${EPREFIX}"/var/log/${PN} \
		--with-modulesdir="${EPREFIX}/usr/$(get_libdir)"/${PN}/modules \
		--without-privatelibdir \
		--with-pidfile="${EPREFIX}"/run/${PN}/ircd.pid \
		--with-tmpdir="${EPREFIX}"/var/lib/${PN}/tmp \
		--with-maxconnections=1024 \
		--with-nick-history=2000 \
		--with-permissions=0640 \
		--with-system-argon2 \
		--with-system-cares \
		--with-system-pcre2 \
		--with-system-sodium \
		--with-system-jansson \
		--enable-dynamic-linking \
		--with-controlfile="${EPREFIX}"/run/${PN}/unrealircd.ctl \
		--enable-ssl="${EPREFIX}"/usr \
		$(use_enable curl libcurl "${EPREFIX}"/usr) \
		$(use_with !operoverride no-operoverride) \
		$(use_with operoverride-verify) \
		$(use_enable geoip libmaxminddb)
}

src_install() {
	keepdir /var/log/${PN}
	keepdir /var/lib/${PN}/tmp

	newbin src/ircd ${PN}
	dobin src/unrealircdctl

	newtmpfiles "${FILESDIR}"/unrealircd.tmpfiles unrealircd.conf

	(
		cd src/modules || die
		for subdir in $(find . -type d -print); do
			if [[ -n $(shopt -s nullglob; echo ${subdir}/*.so) ]]; then
				exeinto /usr/$(get_libdir)/${PN}/modules/"${subdir}"
				doexe "${subdir}"/*.so
			fi
		done
	)

	insinto /etc/${PN}
	# Purposefully omitting the examples/ and ssl/ subdirectories. ssl
	# is redundant with app-misc/ca-certificates and examples will all
	# be in docs anyway.
	doins -r doc/conf/{aliases,help}
	doins doc/conf/*.conf
	newins doc/conf/examples/example.conf ${PN}.conf
	keepdir /etc/${PN}/tls

	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd-r3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r4 ${PN}

	# config should be read-only
	fperms -R 0640 /etc/${PN}
	fperms 0750 /etc/${PN}{,/aliases,/help}
	fperms 0750 /etc/${PN}/tls
	# state is editable but not owned by unrealircd directly
	fperms 0770 /var/log/${PN}
	fperms 0770 /var/lib/${PN}{,/tmp}
	fowners -R root:unrealircd /{etc,var/{lib,log}}/${PN}

	# By default looks in /etc/unrealircd/ssl/curl-ca-bundle.crt. Fix
	# that to look for ca-certificates-provided file instead. %s is
	# CONFDIR. #618066
	dosym ../../ssl/certs/ca-certificates.crt /etc/${PN}/tls/curl-ca-bundle.crt

	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	tmpfiles_process unrealircd.conf

	# Move docert call from src_install() to install_cert in pkg_postinst for
	# bug #201682
	if [[ ! -f "${EROOT}"/etc/${PN}/tls/server.cert.key ]]; then
		if [[ -f "${EROOT}"/etc/${PN}/ssl/server.cert.key ]]; then
			ewarn "The location ${PN} looks for SSL certificates has changed"
			ewarn "from ${EROOT}/etc/${PN}/ssl to ${EROOT}/etc/${PN}/tls."
			ewarn "Please move your existing certificates."
		else
			(
				umask 0037
				install_cert /etc/${PN}/tls/server.cert
				chown unrealircd "${EROOT}"/etc/${PN}/tls/server.cert.*
				ln -snf server.cert.key "${EROOT}"/etc/${PN}/tls/server.key.pem
			)
		fi
	fi

	local unrealircd_conf="${EROOT}"/etc/${PN}/${PN}.conf
	# Fix up the default cloak keys.
	if grep -qe '"and another one";$' "${unrealircd_conf}" && grep -qe '"Oozahho1raezoh0iMee4ohvegaifahv5xaepeitaich9tahdiquaid0geecipahdauVaij3zieph4ahi";$' "${unrealircd_conf}"; then
		ebegin "Generating cloak-keys"
		local keys=(
			$(su ${PN} -s /bin/sh -c "${PN} -k 2>&1 | tail -n 6 | head -n 3")
		)
		[[ -n ${keys[0]} || -n ${keys[1]} || -n ${keys[2]} ]]
		eend $?

		ebegin "Substituting cloak-keys into ${unrealircd_conf}"
		sed -i \
			-e '/cloak-keys/ {
n
s/"Oozahho1raezoh0iMee4ohvegaifahv5xaepeitaich9tahdiquaid0geecipahdauVaij3zieph4ahi";/'${keys[0]}'/
n
s/"and another one";/'${keys[1]}'/
n
s/"and another one";/'${keys[2]}'/
}' \
			"${unrealircd_conf}"
		eend $?
	fi

	elog "UnrealIRCd will not run until you've set up ${EROOT}/etc/unrealircd/unrealircd.conf"
	elog
	elog "You can also configure ${PN} start at boot with rc-update(1)."
	elog "It is recommended to run unrealircd as an unprivileged user."
	elog "The provided init.d script does this for you."
}
