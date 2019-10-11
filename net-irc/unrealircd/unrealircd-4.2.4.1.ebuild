# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SSL_CERT_MANDATORY=1
inherit eapi7-ver ssl-cert

DESCRIPTION="An advanced Internet Relay Chat daemon"
HOMEPAGE="https://www.unrealircd.org/"
SRC_URI="https://www.unrealircd.org/${PN}$(ver_cut 1)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux"
IUSE="class-nofakelag curl +extban-stacking libressl +operoverride operoverride-verify
	+prefixaq showlistmodes shunnotices +usermod"

RDEPEND="
	acct-group/unrealircd
	acct-user/unrealircd
	>=app-crypt/argon2-20171227-r1:=
	dev-libs/libpcre2
	>=net-dns/c-ares-1.7:=
	net-libs/libnsl:=
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	curl? ( net-misc/curl[adns] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( doc/{Authors,Donation,RELEASE-NOTES{,.old},tao.of.irc,technical/,translations.txt} )

pkg_pretend() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		ver_test "${v}" -ge 4 && continue
		ewarn "The configuration file format has changed since ${v}."
		ewarn "Please be prepared to manually update them and visit:"
		ewarn "https://www.unrealircd.org/docs/Upgrading_from_3.2.x"
		break
	done
}

src_prepare() {
	# QA check against bundled pkgs
	rm -r extras || die

	if use class-nofakelag; then
		sed -i -e 's:#undef\( FAKELAG_CONFIGURABLE\):#define\1:' include/config.h || die
	fi

	# By default looks in /etc/unrealircd/ssl/curl-ca-bundle.crt. Fix
	# that to look for ca-certificates-provided file instead. %s is
	# CONFDIR. #618066
	sed -i -e 's:%s/ssl/curl-ca-bundle.crt:%s/../ssl/certs/ca-certificates.crt:' src/s_conf.c || die

	eapply_user
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
		--with-modulesdir="${EPREFIX}"/usr/"$(get_libdir)"/${PN}/modules \
		--without-privatelibdir \
		--with-pidfile="${EPREFIX}"/run/${PN}/ircd.pid \
		--with-tmpdir="${EPREFIX}"/var/lib/${PN}/tmp \
		--with-maxconnections=1024 \
		--with-nick-history=2000 \
		--with-sendq=3000000 \
		--with-permissions=0640 \
		--with-system-argon2 \
		--with-system-cares \
		--with-system-pcre2 \
		--without-tre \
		--enable-dynamic-linking \
		--enable-ssl="${EPREFIX}"/usr \
		$(use_enable curl libcurl "${EPREFIX}"/usr) \
		$(use_enable prefixaq) \
		$(use_with showlistmodes) \
		$(use_with shunnotices) \
		$(use_with !operoverride no-operoverride) \
		$(use_with operoverride-verify) \
		$(use_with !usermod disableusermod) \
		$(use_with !extban-stacking disable-extendedban-stacking)
}

src_install() {
	keepdir /var/log/${PN}
	keepdir /var/lib/${PN}/tmp

	newbin src/ircd ${PN}

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
	keepdir /etc/${PN}/ssl

	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r3 ${PN}

	# config should be read-only
	fperms -R 0640 /etc/${PN}
	fperms 0750 /etc/${PN}{,/aliases,/help}
	fperms 0750 /etc/${PN}/ssl
	# state is editable but not owned by unrealircd directly
	fperms 0770 /var/log/${PN}
	fperms 0770 /var/lib/${PN}{,/tmp}
	fowners -R root:unrealircd /{etc,var/{lib,log}}/${PN}
}

pkg_postinst() {
	# Move docert call from src_install() to install_cert in pkg_postinst for
	# bug #201682
	if [[ ! -f "${EROOT}"etc/${PN}/ssl/server.cert.key ]]; then
		if [[ -f "${EROOT}"etc/${PN}/server.cert.key ]]; then
			ewarn "The location ${PN} looks for SSL certificates has changed"
			ewarn "from ${EROOT}etc/${PN} to ${EROOT}etc/${PN}/ssl."
			ewarn "Please move your existing certificates."
		else
			(
				umask 0037
				install_cert /etc/${PN}/ssl/server.cert
				chown unrealircd "${EROOT}"etc/${PN}/ssl/server.cert.*
				ln -snf server.cert.key "${EROOT}"etc/${PN}/ssl/server.key.pem
			)
		fi
	fi

	local unrealircd_conf="${EROOT}"etc/${PN}/${PN}.conf
	# Fix up the default cloak keys.
	if grep -qe '"and another one";$' "${unrealircd_conf}" && grep -qe '"aoAr1HnR6gl3sJ7hVz4Zb7x4YwpW";$' "${unrealircd_conf}"; then
		ebegin "Generating cloak-keys"
		local keys=(
			$(su ${PN} -s /bin/sh -c "${PN} -k 2>&1 | tail -n 3")
		)
		[[ -n ${keys[0]} || -n ${keys[1]} || -n ${keys[2]} ]]
		eend $?

		ebegin "Substituting cloak-keys into ${unrealircd_conf}"
		sed -i \
			-e '/cloak-keys/ {
n
s/"aoAr1HnR6gl3sJ7hVz4Zb7x4YwpW";/"'"${keys[0]}"'";/
n
s/"and another one";/"'"${keys[1]}"'";/
n
s/"and another one";/"'"${keys[2]}"'";/
}' \
			"${unrealircd_conf}"
		eend $?
	fi

	elog "UnrealIRCd will not run until you've set up /etc/unrealircd/unrealircd.conf"
	elog
	elog "You can also configure ${PN} start at boot with rc-update(1)."
	elog "It is recommended to run unrealircd as an unprivileged user."
	elog "The provided init.d script does this for you."
}
