# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A selection of tools from Debian"
HOMEPAGE="https://packages.qa.debian.org/d/debianutils.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="BSD GPL-2 SMAIL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~x86-linux"
IUSE="+installkernel split-usr static systemd-boot"

# this is for kernel-install script, so [gnuefi] not necessary
RDEPEND="systemd-boot? ( || ( sys-apps/systemd sys-apps/systemd-boot ) )"

PATCHES=( "${FILESDIR}"/${PN}-3.4.2-no-bs-namespace.patch )

src_configure() {
	use static && append-ldflags -static
	default
}

src_install() {
	into /
	dobin tempfile run-parts
	if use systemd-boot ; then
		dodir /sbin
		dosym ../$(usex split-usr 'usr/' '')bin/kernel-install \
			/sbin/installkernel
	elif use installkernel ; then
		dosbin installkernel
	fi

	into /usr
	dosbin savelog

	doman tempfile.1 run-parts.8 savelog.8
	if use installkernel && ! use systemd-boot; then
		doman installkernel.8
	fi
	cd debian || die
	dodoc changelog control
	keepdir /etc/kernel/postinst.d
}
