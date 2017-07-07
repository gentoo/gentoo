# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.17.90[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.15.4[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( >=dev-libs/libxml2-2.9.1 )
"

src_prepare() {
	# Upstream forgot to put this in tarball, upstream #770615
	cp -n "${FILESDIR}"/${PN}-2.20.0-tests-data/*.xml "${S}"/tests/data/ || die

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure --enable-p2p $(use_with test tests)
}

multilib_src_test() {
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session"
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
