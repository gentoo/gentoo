# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISABLE_AUTOFORMATTING=1
FORCE_PRINT_ELOG=1
PYTHON_COMPAT=( python3_{11..13} )

inherit cmake python-any-r1 systemd readme.gentoo-r1
DESCRIPTION="An unidentifiable mechanism that helps you bypass GFW"
HOMEPAGE="https://github.com/trojan-gfw/trojan"
if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/trojan-gfw/trojan.git"
else
	SRC_URI="https://github.com/trojan-gfw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="mysql +nat +reuseport tcpfastopen test"

# Some hiccups setting up local network server.
RESTRICT="test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/openssl:0=
	mysql? ( dev-db/mysql-connector-c:= )
"
DEPEND="${RDEPEND}
	acct-group/trojan
	acct-user/trojan
	test? ( net-misc/curl ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}/${P}-cmake-minreqver-3.10.patch" # bug 964571
	"${FILESDIR}/${P}-boost-1.89.patch" # bug 963419
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -i -e "/User/s/nobody/trojan/g" \
		examples/trojan.service-example || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_MYSQL=$(usex mysql)
		-DENABLE_NAT=$(usex nat)
		-DENABLE_REUSE_PORT=$(usex reuseport)
		-DFORCE_TCP_FASTOPEN=$(usex tcpfastopen)
		-DSYSTEMD_SERVICE=ON
		-DSYSTEMD_SERVICE_PATH=$(systemd_get_systemunitdir)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}/trojan.initd" trojan

	readme.gentoo_create_doc
}

src_test() {
	cmake_src_test -j1
}

pkg_postinst() {
	readme.gentoo_print_elog
}
