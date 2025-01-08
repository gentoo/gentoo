# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd readme.gentoo-r1

DESCRIPTION="A reliable, low-latency, and anti-censorship virtual private network"
HOMEPAGE="https://github.com/lanthora/candy"
SRC_URI="https://github.com/lanthora/candy/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/poco:=
	dev-libs/openssl:=
	dev-libs/spdlog:=
	dev-libs/libfmt:=
"
RDEPEND="
	${DEPEND}
"

src_install(){
	cmake_src_install
	default

	insinto /etc
	doins candy.cfg

	systemd_dounit candy.service
	systemd_dounit candy@.service
	newinitd candy.initd candy

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
