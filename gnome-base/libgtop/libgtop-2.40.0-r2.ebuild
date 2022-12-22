# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_EAUTORECONF="yes"
inherit flag-o-matic gnome2

DESCRIPTION="A library that provides top functionality to applications"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgtop"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="2/11" # libgtop soname version
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.26:2
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/gtk-doc-am-1.4
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}"/patches # patches from master (not stable branch) that seem safe and fix potential eautoreconf problems
	"${FILESDIR}"/${PV}-sandbox-workaround.patch # requires suid handling in ebuild - https://gitlab.gnome.org/GNOME/libgtop/issues/48
	"${FILESDIR}"/${PV}-clang.patch
)

src_configure() {
	# Add explicit stdc, bug #628256
	append-cflags "-std=c99"

	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install
	chmod 4755 "${ED}"/usr/bin/libgtop_server2 || die
}
