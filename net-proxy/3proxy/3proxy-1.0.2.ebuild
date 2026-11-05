# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit cmake eapi9-ver python-any-r1 systemd verify-sig

DESCRIPTION="Really tiny cross-platform proxy servers set"
HOMEPAGE="
	https://3proxy.org/
	https://github.com/3proxy/3proxy/
"
SRC_URI="
	https://github.com/3proxy/3proxy/releases/download/${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/3proxy/3proxy/releases/download/${PV}/${P}.tar.gz.asc )
"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="ftp +http-server mail modules odbc pam pcre ssl test"
REQUIRED_USE="test? ( http-server pcre ssl )"
RESTRICT="!test? ( test )"

DEPEND="
	odbc? ( dev-db/unixODBC )
	pam? ( sys-libs/pam )
	pcre? ( dev-libs/libpcre2:= )
	ssl? ( dev-libs/openssl:= )
"
RDEPEND="
	${DEPEND}
	acct-group/3proxy
	acct-user/3proxy
"
BDEPEND="
	test? ( ${PYTHON_DEPS} )
	verify-sig? ( sec-keys/openpgp-keys-3proxy )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.7-install_systemd_unit.patch
	"${FILESDIR}"/${PN}-0.9.7-systemd_unit_owner.patch
)

HTML_DOCS=( doc/html/. )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-D3PROXY_BINARY_PREFIX="3proxy-"
		-D3PROXY_BUILD_NONE=$(usex !modules)
		-D3PROXY_USE_HTTPSRV=$(usex http-server)
		-D3PROXY_USE_PAM=$(usex pam)
		-D3PROXY_USE_PCRE2=$(usex pcre)
		-D3PROXY_USE_ODBC=$(usex odbc)

		# FTP
		-D3PROXY_USE_FTP=$(usex ftp)
		-D3PROXY_BUILD_FTPPR=$(usex modules $(usex ftp))

		# MAIL
		-D3PROXY_USE_MAILPROXY=$(usex mail)
		-D3PROXY_BUILD_IMAPP=$(usex modules $(usex mail))
		-D3PROXY_BUILD_POP3P=$(usex modules $(usex mail))
		-D3PROXY_BUILD_SMTPP=$(usex modules $(usex mail))

		# SSL
		-D3PROXY_USE_OPENSSL=$(usex ssl)
		-D3PROXY_USE_WOLFSSL=OFF
	)
	cmake_src_configure
}

src_test() {
	"${EPYTHON}" tests/run.py --keep --bin "${BUILD_DIR}"/bin/3proxy || die
}

src_install() {
	cmake_src_install

	dodoc -r cfg

	mv "${ED}"/etc/3proxy/3proxy.cfg{,.sample} || die
	# pidfile not used by the system service
	sed -e 's:^pidfile:#pidfile:' -i "${ED}"/etc/3proxy/3proxy.cfg.sample || die

	fowners -R 3proxy:3proxy /etc/3proxy
	fperms 700 /etc/3proxy
	fperms 600 /etc/3proxy/3proxy.cfg.sample

	newinitd "${FILESDIR}"/3proxy.initd 3proxy
	systemd_dounit "${BUILD_DIR}"/3proxy.service
}

pkg_postinst() {
	if ver_replacing -lt 0.9.7; then
		ewarn "The plugins for ${PN} are installed in ${EROOT}/usr/$(get_libdir)/${PN}"
		ewarn "Please update the paths to the plugins in ${EROOT}/etc/${PN}/${PN}.cfg"
	fi
}
