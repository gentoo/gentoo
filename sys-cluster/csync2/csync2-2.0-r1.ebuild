# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Cluster synchronization tool"
HOMEPAGE="http://oss.linbit.com/csync2/"
SRC_URI="http://oss.linbit.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="mysql postgres sqlite ssl xinetd"

RDEPEND=">=net-libs/librsync-0.9.5
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( >=dev-db/sqlite-3.0 )
	ssl? ( >=net-libs/gnutls-2.7.3 )
	xinetd? ( sys-apps/xinetd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="|| ( mysql postgres sqlite )"
SLOT="0"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${P} \
		--localstatedir=/var \
		--sysconfdir=/etc/csync2 \
		$(use_enable mysql) \
		$(use_enable postgres) \
		$(use_enable sqlite sqlite3) \
		$(use_enable ssl gnutls)
}

src_install() {
	# Parallel install fails, bug #561382
	emake -j1 DESTDIR="${D}" install

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/${PN}.xinetd ${PN}
	fi

	keepdir /var/lib/csync2

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	if use xinetd; then
		echo
		einfo "After you setup your conf file, edit the xinetd"
		einfo "entry in /etc/xinetd.d/${PN} to enable, then"
		einfo "start xinetd: /etc/init.d/xinetd start"
	fi
	echo
	einfo "To add ${PN} to your services file"
	if use ssl; then
		einfo "and to generate the SSL certificates,"
	fi
	einfo "just run this command after you install:"
	echo
	einfo "emerge  --config =${PF}"
	echo
	einfo "Now you can find csync2.cfg under /etc/${PN}"
	einfo "Please move you old config to the right location"
	echo
	einfo "To start csync2 as a standalone daemon, simply run:"
	einfo "/etc/init.d/csync2 start"
	echo
}

pkg_config() {
	einfo "Updating ${ROOT}/etc/services"
	{ grep -v ^${PN} "${ROOT}"/etc/services;
	echo "csync2  30865/tcp"
	} > "${ROOT}"/etc/services.new
	mv -f "${ROOT}"/etc/services.new "${ROOT}"/etc/services

	if use ssl; then
		if [ ! -f "${ROOT}"/etc/${PN}/csync2_ssl_key.pem ]; then
			einfo "Creating default certificate in ${ROOT}/etc/${PN}"

			openssl genrsa -out "${ROOT}"/etc/${PN}/csync2_ssl_key.pem 1024 &> /dev/null

			yes '' | \
			openssl req -new \
				-key "${ROOT}"/etc/${PN}/csync2_ssl_key.pem \
				-out "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr \
				&> "${ROOT}"/dev/null

			openssl x509 -req -days 600 \
				-in "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr \
				-signkey "${ROOT}"/etc/${PN}/csync2_ssl_key.pem \
				-out "${ROOT}"/etc/${PN}/csync2_ssl_cert.pem \
				&> "${ROOT}"/dev/null

			rm "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr
			chmod 400 "${ROOT}"/etc/${PN}/csync2_ssl_key.pem "${ROOT}"/etc/${PN}/csync2_ssl_cert.pem
		fi
	fi
}
