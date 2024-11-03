# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit meson python-single-r1 readme.gentoo-r1 xdg

DESCRIPTION="RGB lighting management software for GNU/Linux powered by OpenRazer"
HOMEPAGE="https://polychromatic.app/
	https://github.com/polychromatic/polychromatic/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.20:3[introspection]
	$(python_gen_cond_dep '
		dev-python/PyQt6-WebEngine[${PYTHON_USEDEP}]
		dev-python/PyQt6[svg,${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colour[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		sys-apps/openrazer[client,${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	dev-util/intltool
	dev-lang/sassc
"

DOC_CONTENTS="To automatically start up Polychromatic on session login copy
/usr/share/polychromatic/polychromatic-autostart.desktop file into Your user's
~/.config/autostart/ directory."

src_test() {
	rm -rf "locale" || die
	ln -svf "${BUILD_DIR}/locale" "locale" || die
	PYTHONPATH="tests:${PYTHONPATH}" "${EPYTHON}" "tests/runner.py" || die
}

src_install() {
	meson_src_install
	python_optimize
	readme.gentoo_create_doc

	python_doscript "${S}"/polychromatic-{cli,controller,helper,tray-applet}

	# Do not force polychromatic to autostart on session login.
	# Move it into /usr/share/polychromatic and treat it as an example file
	# that could be installed into user's ~/.config/autostart/ directory.
	mv "${ED}/etc/xdg/autostart/${PN}-autostart.desktop" \
	   "${ED}/usr/share/${PN}/${PN}-autostart.desktop" || die
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
