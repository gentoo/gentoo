# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic

DESCRIPTION="A selection of tools from Debian"
HOMEPAGE="https://packages.qa.debian.org/d/debianutils.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="BSD GPL-2 SMAIL"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-linux"
IUSE="kernel_linux static"

PATCHES=( "${FILESDIR}"/${PN}-3.4.2-no-bs-namespace.patch )

S="${WORKDIR}/${PN}"

src_configure() {
	use static && append-ldflags -static
	default
}

src_install() {
	into /
	dobin tempfile run-parts
	if use kernel_linux ; then
		dosbin installkernel
	fi

	into /usr
	dosbin savelog

	doman tempfile.1 run-parts.8 savelog.8
	use kernel_linux && doman installkernel.8
	cd debian || die
	dodoc changelog control
	keepdir /etc/kernel/postinst.d
}
