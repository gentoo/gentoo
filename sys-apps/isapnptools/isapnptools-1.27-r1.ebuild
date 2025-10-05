# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a

DESCRIPTION="Tools for configuring ISA PnP devices"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/hardware/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-incompatible-pointer-types.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_configure() {
	lto-guarantee-fat
	default
}

src_install() {
	default
	strip-lto-bytecode

	dodir /sbin
	mv "${ED}"/{usr/sbin/isapnp,sbin/} || die

	docinto txt
	dodoc doc/{README*,*.txt} test/*.txt
	dodoc etc/isapnp.*

	newinitd "${FILESDIR}"/isapnp.rc isapnp
}
