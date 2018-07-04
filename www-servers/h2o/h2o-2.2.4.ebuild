# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CMAKE_MAKEFILE_GENERATOR="emake"
USE_RUBY="ruby23 ruby24"

inherit cmake-utils ruby-single systemd user

DESCRIPTION="H2O - the optimized HTTP/1, HTTP/2 server"
HOMEPAGE="https://h2o.examp1e.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl +mruby"

RDEPEND="dev-lang/perl
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}
	mruby? (
		sys-devel/bison
		${RUBY_DEPS}
	)"

PATCHES=( "${FILESDIR}"/${P}-libressl.patch )

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}"/etc/${PN}
		-DWITH_MRUBY=$(usex mruby)
		-DWITHOUT_LIBS=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	keepdir /var/www/localhost/htdocs

	insinto /etc/${PN}
	doins "${FILESDIR}"/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	fperms 0750 /var/log/${PN}
}
