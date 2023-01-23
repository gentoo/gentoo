# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Spindown is a daemon that can spin down idle disks"
HOMEPAGE="https://code.google.com/p/spindown"
SRC_URI="https://spindown.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/sg3_utils"

PATCHES=(
	"${FILESDIR}"/${P}-CFLAGS-LDFLAGS.patch
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-musl-time-include.patch
)

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	insinto /etc
	newins spindown.conf.example spindown.conf

	newinitd "${FILESDIR}"/spindownd.initd-r1 spindownd
	newconfd "${FILESDIR}"/spindownd.confd-r1 spindownd

	dosbin spindownd
	dodoc CHANGELOG README TODO spindown.conf.example
}

pkg_postinst() {
	elog "Before starting spindownd the first time"
	elog "you should modify ${EROOT}/etc/spindown.conf"
	elog
	elog "To start spindownd by default"
	elog "you should add it to the default runlevel:"
	elog "  rc-update add spindownd default"
}
