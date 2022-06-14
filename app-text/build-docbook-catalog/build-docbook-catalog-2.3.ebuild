# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/"
SRC_URI="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-libs/libxml2
	|| ( sys-apps/util-linux app-misc/getopt )
"

src_prepare() {
	default

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
	build-docbook-catalog || die "Failed to regenerate docbook catalog."
}
