# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
LUA_COMPAT=( lua5-{1..4} )

inherit autotools gnome2 lua-single multilib-minimal

DESCRIPTION="GTK+2 standard engines and themes"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="accessibility lua"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

# Lua dependency uses lua_gen_impl_dep() because LUA_REQ_USE doesn't seem
# to play nicely with MULTILIB_USEDEP.
RDEPEND="
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	lua? ( $(lua_gen_impl_dep "${MULTILIB_USEDEP}") )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.31
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-glib.h.patch
	"${FILESDIR}"/${P}-java-look.patch
	"${FILESDIR}"/${P}-auto-mnemonics.patch
	"${FILESDIR}"/${P}-change-bullet.patch
	"${FILESDIR}"/${P}-tooltips.patch
	"${FILESDIR}"/${P}-window-dragging.patch
)

src_prepare() {
	gnome2_src_prepare
	# pkgconfig wrapper set up by lua-single.eclass is not multilib-compatible
	# at present so point Autoconf directly to the correct implementation.
	# We patch configure rather than configure.ac because running 'eautoreconf'
	# results for some reason in corrupted test Makefiles.
	sed -i -e "s|\"lua\"|\"${ELUA}\"|g" configure || die
}

multilib_src_configure() {
	local confopts=(
		--enable-animation
		$(use_enable lua)
		$(use_with lua system-lua)
	)
	ECONF_SOURCE=${S} gnome2_src_configure "${confopts[@]}"
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	einstalldocs
}
