# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DL_ID=2195
MY_PN=openvasmd
inherit cmake-utils systemd

DESCRIPTION="A remote security scanner for Linux (openvas-manager)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/${DL_ID}/${P/_beta/+beta}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND="
	dev-db/redis
	>=dev-db/sqlite-3
	>=net-analyzer/openvas-libraries-8.0.5
"
RDEPEND="${DEPEND}
	!net-analyzer/openvas-administrator
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}"/${P}

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.1-bsdsource.patch
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

	insinto /etc/openvas/
	doins "${FILESDIR}"/${MY_PN}-daemon.conf
	dosym ../openvas/${MY_PN}-daemon.conf /etc/conf.d/${MY_PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${MY_PN}.logrotate ${MY_PN}

	newinitd "${FILESDIR}"/${MY_PN}.init ${MY_PN}
	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
