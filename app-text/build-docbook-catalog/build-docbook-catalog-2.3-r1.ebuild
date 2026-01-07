# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/"
SRC_URI="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-libs/libxml2
	|| ( sys-apps/util-linux app-misc/getopt )
"

src_prepare() {
	default

	sed -i -e "1s@#!@#!${EPREFIX}@" build-docbook-catalog || die
	sed -i -e "/^EPREFIX=/s:=.*:='${EPREFIX}':" build-docbook-catalog || die
	has_version sys-apps/util-linux || sed -i -e '/^GETOPT=/s/getopt/&-long/' build-docbook-catalog || die
}

src_configure() {
	# export for bug #490754
	export MAKEOPTS+=" EPREFIX=${EPREFIX}"

	default
}

pkg_postinst() {
	# New version -> regen files
	# See bug #816303 for rationale behind die
	"${EROOT}"/usr/sbin/build-docbook-catalog || die "Failed to regenerate docbook catalog."
}
