# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson xdg

DESCRIPTION="Highly customizable & functional document viewer"
HOMEPAGE="https://pwmt.org/projects/zathura/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura.git"
else
	SRC_URI="https://github.com/pwmt/zathura/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="ZLIB"
SLOT="0/6.7" # plugin versions api.abi (see meson.build)
IUSE="+man landlock seccomp synctex test wayland X"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	test? ( X )
	|| ( wayland X )
"

RDEPEND="
	dev-libs/json-glib
	dev-db/sqlite:3
	>=dev-libs/girara-0.4.5-r1:=[X?]
	>=dev-libs/glib-2.76:2
	sys-apps/file
	x11-libs/cairo
	>=x11-libs/gtk+-3.24:3[wayland?,X?]
	x11-libs/pango
	man? ( dev-python/sphinx )
	seccomp? ( sys-libs/libseccomp )
	synctex? ( app-text/texlive-core )
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-5.13
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		dev-libs/appstream
		x11-misc/xvfb-run
	)
"

src_configure() {
	# defang automagic dependencies
	use X || append-flags -DGENTOO_GTK_HIDE_X11
	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	local emesonargs=(
		-Dconvert-icon=disabled
		$(meson_feature man manpages)
		$(meson_feature landlock)
		$(meson_feature seccomp)
		$(meson_feature synctex)
		$(meson_feature test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use seccomp || use landlock; then
		mv "${ED}"/usr/bin/zathura{,-full} || die
		dosym zathura-sandbox /usr/bin/zathura
	fi
}

pkg_postinst() {
	if use seccomp || use landlock; then
		elog "Zathura has been installed as a symlink to zathura-sandbox due to USE"
		elog "seccomp or USE landlock.  Some features such as printing or hyperlinks"
		elog "may be unavailable when running with the default executable (zathura)."
		elog "If you require these features, you can temporarily switch to using"
		elog "zathura-full or disable these use flags."
		if ! use elibc_glibc; then
			ewarn ""
			ewarn "Upstream zathura does not test sandboxing rules on non-glibc"
			ewarn "environments.  Your mileage may vary using the sandboxed variant."
		fi
	fi
}
