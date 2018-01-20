# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd tmpfiles toolchain-funcs

DESCRIPTION="Policy routing daemon with failover and load-balancing"
HOMEPAGE="https://github.com/ncopa/pingu"
SRC_URI="https://github.com/ncopa/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="dev-libs/libev"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	virtual/pkgconfig
	doc? ( app-text/asciidoc )"

PATCHES=(
	# Add missed parameters to configure
	"${FILESDIR}"/${P}-configure.patch
	# Fix compilation issue
	"${FILESDIR}"/${P}-icmp.patch
	# Change path to /run and fix QA
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	econf $(use_enable debug) $(use_enable doc)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	keepdir /var/lib/pingu
	insinto /etc/pingu
	newins pingu.conf pingu.conf.example
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
