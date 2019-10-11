# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2 multilib-minimal

DESCRIPTION="A LGPL version of libart"
HOMEPAGE="https://www.levien.com/libart"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

# The provided tests are interactive only
RESTRICT="test"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/libart2-config
)

src_prepare() {
	gnome2_src_prepare

	# Fix crosscompiling, bug #185684
	rm "${S}"/art_config.h || die
	eapply "${FILESDIR}"/${PN}-2.3.21-crosscompile.patch

	# Do not build tests if not required
	eapply "${FILESDIR}"/${PN}-2.3.21-no-test-build.patch

	mv configure.in configure.ac || die
	AT_NOELIBTOOLIZE=yes eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static
}

multilib_src_install() {
	gnome2_src_install
}
