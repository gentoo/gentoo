# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="https://sources.gentoo.org/gentoo-src/build-docbook-catalog/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~haubi/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="|| ( sys-apps/util-linux app-misc/getopt )
	!<app-text/docbook-xsl-stylesheets-1.73.1
	dev-libs/libxml2"
DEPEND=""

pkg_setup() {
	# export for bug #490754
	export MAKEOPTS+=" EPREFIX=${EPREFIX}"
}

src_prepare() {
	sed -i -e "/^EPREFIX=/s:=.*:='${EPREFIX}':" build-docbook-catalog || die
	has_version sys-apps/util-linux || sed -i -e '/^GETOPT=/s/getopt/&-long/' build-docbook-catalog || die
}

pkg_postinst() {
	# New version -> regen files
	build-docbook-catalog
}
