# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A client and server for Peercast P2P-radio network"
HOMEPAGE="http://www.peercast.org"
SRC_URI="http://www.peercast.org/src/${P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}/${P}-CVE-2008-2040.patch" \
	"${FILESDIR}/${PN}-0.1216-makefile.patch" \
	"${FILESDIR}/${PN}-0.1216-amd64.patch" \
	"${FILESDIR}/${P}-glibc-2.10.patch"
)

src_compile() {
	append-ldflags -pthread

	cd ui/linux
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" LDFLAGS="${LDFLAGS}" \
		LD="$(tc-getCXX)"
}

src_install() {
	dosbin ui/linux/peercast

	insinto /usr/share/peercast
	doins -r ui/html

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	elog "Start Peercast with '/etc/init.d/peercast start' and point your"
	elog "webbrowser to 'http://localhost:7144' to start using Peercast."
	elog
	elog "You can also run 'rc-update add peercast default' to make Peercast"
	elog "start at boot."
}
