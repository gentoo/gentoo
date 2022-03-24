# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A selection of tools from Debian"
HOMEPAGE="https://packages.qa.debian.org/d/debianutils.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD GPL-2 SMAIL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
IUSE="+installkernel static"

PDEPEND="
	installkernel? (
		|| (
			sys-kernel/installkernel-gentoo
			sys-kernel/installkernel-systemd-boot
		)
	)"

PATCHES=( "${FILESDIR}"/${PN}-3.4.2-no-bs-namespace.patch )

src_prepare() {
	# Avoid adding po4a dependency, upstream refreshes manpages.
	sed -i -e '/SUBDIRS/s|po4a||' Makefile.am || die

	default
	eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	default
}

src_install() {
	into /
	dobin run-parts

	into /usr
	dobin ischroot
	dosbin savelog

	doman ischroot.1 run-parts.8 savelog.8

	dodoc CHANGELOG
}
