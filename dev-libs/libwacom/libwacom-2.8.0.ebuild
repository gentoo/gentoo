# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit meson python-any-r1 udev

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="https://github.com/linuxwacom/libwacom"
SRC_URI="https://github.com/linuxwacom/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/9" # libwacom SONAME
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ppc ppc64 sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? (
		$(python_gen_any_dep '
			dev-python/libevdev[${PYTHON_USEDEP}]
			dev-python/pyudev[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	use test || return 0
	python_has_version \
		"dev-python/libevdev[${PYTHON_USEDEP}]" \
		"dev-python/pyudev[${PYTHON_USEDEP}]" \
		"dev-python/pytest[${PYTHON_USEDEP}]"
}

src_prepare() {
	default

	# Don't call systemd daemon-reload in the test suite
	sed -i -e '/daemon-reload/d' test/test_udev_rules.py || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature doc documentation)
		$(meson_feature test tests)
		-Dudev-dir=$(get_udevdir)
	)
	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
