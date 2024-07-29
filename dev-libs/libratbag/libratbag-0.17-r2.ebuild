# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-single-r1 systemd udev

DESCRIPTION="Library to configure gaming mice"
HOMEPAGE="https://github.com/libratbag/libratbag"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libratbag/libratbag.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc elogind systemd test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ ( elogind systemd )
"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	dev-lang/swig
	virtual/pkgconfig
	doc? (
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		dev-libs/check
		dev-libs/gobject-introspection
		dev-debug/valgrind
		$(python_gen_cond_dep '
			dev-python/evdev[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	${PYTHON_DEPS}
	acct-group/plugdev
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libevdev
	dev-libs/libunistring:=
	virtual/libudev:=
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/evdev[${PYTHON_USEDEP}]
	')
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
DEPEND="
	${RDEPEND}
	dev-libs/gobject-introspection
"

PATCHES=(
	"${FILESDIR}"/libratbag-0.17-python3.12-imp.patch
)

src_prepare() {
	default

	if use elogind ; then
		# Fix systemd includes for elogind
		sed -i -e 's@include <systemd@include <elogind@' \
			ratbagd/ratbag*.c || die
	fi
}

src_configure() {
	python_setup

	local emesonargs=(
		$(meson_use doc documentation)
		$(meson_use systemd)
		$(meson_use test tests)
		-Ddbus-group="plugdev"
		-Dlogind-provider=$(usex elogind elogind systemd)
		-Dsystemd-unit-dir="$(systemd_get_systemunitdir)"
		-Dudev-dir="${EPREFIX}$(get_udevdir)"
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/
	newinitd "${FILESDIR}"/ratbagd.init ratbagd
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog 'You need to be in "plugdev" group in order to access the'
		elog 'ratbagd dbus interface'
	fi
	elog 'You may be required to create and/or be part of the "games" group if you intend on using piper'
}
