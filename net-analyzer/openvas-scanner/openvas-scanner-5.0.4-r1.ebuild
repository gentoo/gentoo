# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DL_ID=2129
MY_PN=openvassd
inherit cmake-utils systemd

DESCRIPTION="A remote security scanner for Linux (OpenVAS-scanner)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="
	app-crypt/gpgme
	>=dev-libs/glib-2.16:2
	dev-libs/libgcrypt:0
	>=net-analyzer/openvas-libraries-8.0.2
"
RDEPEND="${DEPEND}
	!net-analyzer/openvas-plugins
	!net-analyzer/openvas-server
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}"/${P/_beta/+beta}

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.3-mkcertclient.patch
	"${FILESDIR}"/${PN}-4.0.3-rulesdir.patch
	"${FILESDIR}"/${PN}-4.0.3-run.patch
)

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e '/^install.*OPENVAS_CACHE_DIR.*/d' \
		-i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DLOCALSTATEDIR="${EPREFIX}/var"
		-DSYSCONFDIR="${EPREFIX}/etc"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}

	insinto /etc/openvas
	doins "${FILESDIR}"/${MY_PN}.conf "${FILESDIR}"/${MY_PN}-daemon.conf
	dosym ../openvas/${MY_PN}-daemon.conf /etc/conf.d/${MY_PN}

	insinto /etc/logrotate.d
	doins "${FILESDIR}"/${MY_PN}.logrotate

	dodoc "${FILESDIR}"/openvas-nvt-sync-cron

	systemd_newtmpfilesd "${FILESDIR}"/${MY_PN}.tmpfiles.d ${MY_PN}.conf
	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
