# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 gnome.org gnome2-utils meson systemd virtualx xdg

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="https://wiki.gnome.org/Projects/dconf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x86-linux"
IUSE="gtk-doc"
RESTRICT="!test? ( test )" # IUSE=test comes from virtualx.eclass

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	sys-apps/dbus
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-util/gtk-doc-1.15 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/0.40.0-bash-completion-dir.patch
	"${FILESDIR}"/0.32.0-drop-vapigen-dep.patch # .vapi/.deps are pregenerated, just install them without a vala dep
)

src_configure() {
	local emesonargs=(
		-Dbash_completion_dir="$(get_bashcompdir)"
		-Dman=true
		$(meson_use gtk-doc gtk_doc)
		-Dvapi=true
		-Dsystemduserunitdir=$(systemd_get_userunitdir)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# GSettings backend may be one of: memory, gconf, dconf
	# Only dconf is really considered functional by upstream
	# must have it enabled over gconf if both are installed
	# This snippet can't be removed until gconf package is
	# ensured to not install a /etc/env.d/50gconf and then
	# still consider the CONFIG_PROTECT_MASK bit.
	echo 'CONFIG_PROTECT_MASK="/etc/dconf"' >> 51dconf
	echo 'GSETTINGS_BACKEND="dconf"' >> 51dconf
	doenvd 51dconf
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_giomodule_cache_update

	# Kill existing dconf-service processes as recommended by upstream due to
	# possible changes in the dconf private dbus API.
	# dconf-service will be dbus-activated on next use.
	pids=$(pgrep -x dconf-service)
	if [[ $? == 0 ]]; then
		ebegin "Stopping dconf-service; it will automatically restart on demand"
		kill ${pids}
		eend $?
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_giomodule_cache_update
}
