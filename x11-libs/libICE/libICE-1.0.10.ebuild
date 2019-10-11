# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Inter-Client Exchange library"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="ipv6"

DEPEND="x11-base/xorg-proto
	x11-libs/xtrans"
RDEPEND="${DEPEND}
	elibc_glibc? ( dev-libs/libbsd )"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		--disable-docs
		--disable-specs
		--without-fop
	)
}
