# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd

DESCRIPTION="Optimized multi algo CPU miner"
HOMEPAGE="https://github.com/JayDDee/cpuminer-opt"
IUSE="cpu_flags_x86_sse2 curl"
LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE="cpu_flags_x86_sse2"
DEPEND="
	dev-libs/gmp:=
	dev-libs/jansson:=
	>=net-misc/curl-7.15[ssl]
"
RDEPEND="${DEPEND}"
if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/JayDDee/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/JayDDee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	econf --with-crypto --with-curl
}

src_install() {
	default
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto "/etc/${PN}"
	newins config-template.json cpuminer-conf.json
}

src_test() {
	./cpuminer --cputest || die
}
