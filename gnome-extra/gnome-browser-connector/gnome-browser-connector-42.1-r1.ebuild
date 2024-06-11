# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit gnome.org meson python-single-r1 xdg

DESCRIPTION="OS-native connector counterpart for GNOME Shell browser extension"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShellIntegration"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
"
RDEPEND="${DEPEND}
	gnome-base/gnome-shell
"

PATCHES=(
	"${FILESDIR}/${P}-python-path.patch"
)

src_install() {
	meson_src_install
	python_fix_shebang "${D}/usr/bin/${PN}"
	python_fix_shebang "${D}/usr/bin/${PN}-host"
	python_optimize

	if [[ $(get_libdir) != "lib" && "${SYMLINK_LIB}" != yes ]]; then
		# Workaround www-client/firefox-bin manifests location
		# Bug: https://bugs.gentoo.org/643522
		insinto /usr/lib/mozilla/native-messaging-hosts
		for id in chrome_gnome_shell browser_connector; do
			doins "${ED}/usr/$(get_libdir)/mozilla/native-messaging-hosts/org.gnome.${id}.json"
		done
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Please note that this package provides OS-native connector only."
	elog "You can install browser extension using link provided at"
	elog "https://extensions.gnome.org website."
}
