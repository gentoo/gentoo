# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib toolchain-funcs eutils

DESCRIPTION="A program (and preload library) to fake system date"
HOMEPAGE="https://packages.qa.debian.org/d/datefudge.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PATCHES=()

pkg_setup() {
	use userland_BSD && PATCHES+=( "${FILESDIR}"/${P}-bsd.patch )
}

src_prepare() {
	default
	sed -i \
		-e '/dpkg-parsechangelog/d' \
		Makefile || die
	use prefix && sed -i -e '/-o root -g root/d' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" libdir="/usr/$(get_libdir)" VERSION="${PV}"
}

src_install() {
	emake DESTDIR="${ED}" CC="$(tc-getCC)" libdir="/usr/$(get_libdir)" install
	einstalldocs
}
