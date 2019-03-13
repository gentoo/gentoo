# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit gnome.org meson python-single-r1 xdg

DESCRIPTION="Customize advanced GNOME 3 options"
HOMEPAGE="https://wiki.gnome.org/Apps/Tweaks"

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
"
# g-s-d, gnome-desktop, gnome-shell etc. needed at runtime for the gsettings schemas
RDEPEND="${COMMON_DEPEND}
	>=dev-python/pygobject-3.10.2:3[${PYTHON_USEDEP}]
	>=gnome-base/gnome-settings-daemon-3

	dev-libs/glib:2
	>=x11-libs/gtk+-3.12:3[introspection]
	>=gnome-base/gnome-desktop-3.6.0.1:3[introspection]
	net-libs/libsoup:2.4[introspection]
	x11-libs/libnotify[introspection]

	>=gnome-base/gsettings-desktop-schemas-3.27.90
	>=gnome-base/gnome-shell-3.24
	x11-wm/mutter
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo-cursor-themes.patch # Add contents of Gentoo's cursor theme directory to cursor theme list
)

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/
}
