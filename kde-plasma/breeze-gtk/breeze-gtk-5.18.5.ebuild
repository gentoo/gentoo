# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PVCUT=$(ver_cut 1-3)
inherit ecm kde.org python-any-r1

DESCRIPTION="Official GTK+ port of Plasma's Breeze widget style"
HOMEPAGE="https://invent.kde.org/plasma/breeze-gtk"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE=""

BDEPEND="${PYTHON_DEPS}
	dev-lang/sassc
	$(python_gen_any_dep 'dev-python/pycairo[${PYTHON_USEDEP}]')
	>=kde-plasma/breeze-${PVCUT}:5
"

python_check_deps() {
	has_version "dev-python/pycairo[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	ecm_pkg_setup
}

src_prepare() {
	ecm_src_prepare
	if has_version "<dev-util/cmake-3.16_rc1"; then
		eapply "${FILESDIR}"/${PN}-5.16.5-cmake-pre-3.16.patch
	fi
}

src_configure() {
	local mycmakeargs=(
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	if has_version "<dev-util/cmake-3.16_rc1"; then
		mycmakeargs=( -DPYTHON_EXECUTABLE="${PYTHON}" )
	fi
	ecm_src_configure
}
