# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake eapi9-ver systemd

DESCRIPTION="Really tiny cross-platform proxy servers set"
HOMEPAGE="
	https://3proxy.org/
	https://github.com/3proxy/3proxy/
"
SRC_URI="https://github.com/3proxy/3proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="odbc pam pcre ssl"

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

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.7-install_systemd_unit.patch
	"${FILESDIR}"/${PN}-0.9.7-systemd_unit_owner.patch

	# backport
	"${FILESDIR}"/${P}-fix_install_plugins.patch
)

HTML_DOCS=( doc/html/. )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-D3PROXY_BINARY_PREFIX="3proxy-"
		-D3PROXY_USE_OPENSSL=$(usex ssl)
		-D3PROXY_USE_PAM=$(usex pam)
		-D3PROXY_USE_PCRE2=$(usex pcre)
		-D3PROXY_USE_ODBC=$(usex odbc)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc -r cfg

	mv "${ED}"/etc/3proxy/3proxy.cfg{,.sample} || die

	fowners -R 3proxy:3proxy /etc/3proxy
	fperms -R 600 /etc/3proxy

	newinitd "${FILESDIR}"/3proxy.initd 3proxy
	systemd_dounit "${BUILD_DIR}"/3proxy.service
}

pkg_postinst() {
	if ver_replacing -lt 0.9.7; then
		ewarn "The plugins for ${PN} are installed in ${EROOT}/usr/$(get_libdir)/${PN}"
		ewarn "Please update the paths to the plugins in ${EROOT}/etc/${PN}/${PN}.cfg"
	fi
}
