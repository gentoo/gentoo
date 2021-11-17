# Copyright 2014-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit meson python-any-r1 udev

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libinput/ https://gitlab.freedesktop.org/libinput/libinput"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/10"
[[ "$(ver_cut 3)" -gt 900 ]] || \
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~s390 sparc x86"
IUSE="doc input_devices_wacom test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/commonmark[${PYTHON_USEDEP}]
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			>=dev-python/sphinx_rtd_theme-0.2.4[${PYTHON_USEDEP}]
		')
		>=app-doc/doxygen-1.8.3
		>=media-gfx/graphviz-2.38.0
	)
"
#	test? ( dev-util/valgrind )
RDEPEND="
	input_devices_wacom? ( >=dev-libs/libwacom-0.27 )
	>=dev-libs/libevdev-1.9.902
	>=sys-libs/mtdev-1.1
	virtual/libudev:=
	virtual/udev
"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/check-0.9.10 )"

python_check_deps() {
	has_version -b "dev-python/commonmark[${PYTHON_USEDEP}]" && \
	has_version -b "dev-python/recommonmark[${PYTHON_USEDEP}]" && \
	has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" && \
	has_version -b ">=dev-python/sphinx_rtd_theme-0.2.4[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed "s@, '-Werror'@@" -i meson.build || die #744250
}

src_configure() {
	# gui can be built but will not be installed
	local emesonargs=(
		-Ddebug-gui=false
		$(meson_use doc documentation)
		$(meson_use input_devices_wacom libwacom)
		$(meson_use test tests)
		-Dudev-dir="${EPREFIX}$(get_udevdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc ; then
		docinto html
		dodoc -r "${BUILD_DIR}"/Documentation/.
	fi
}

pkg_postinst() {
	pkgname="dev-python/python-libevdev"
	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version "${pkgname}" ; then
		einfo "${pkgname} must be installed to use the"
		einfo "libinput measure and libinput replay tools."
	fi

	udevadm hwdb --update --root="${ROOT}"
}
