# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-any-r1

DESCRIPTION="X keyboard configuration database"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"
	inherit git-r3
else
	SRC_URI="https://www.x.org/releases/individual/data/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-lang/perl
	dev-libs/libxslt
	sys-devel/gettext
	test? (
		${PYTHON_DEPS}
		x11-apps/xkbcomp
		x11-libs/libxkbcommon
		$(python_gen_any_dep '
			dev-python/pycountry[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/pycountry[${PYTHON_USEDEP}]"
	python_has_version "dev-python/pytest-xdist[${PYTHON_USEDEP}]"
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	eapply_user

	# Remove pytest timeout
	sed -i -e "/test('pytest'/,/)$/ { s/timeout: [0-9]*/timeout: 0/ }" meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dxkb-base="${EPREFIX}/usr/share/X11/xkb"
		-Dcompat-rules=true
	)
	meson_src_configure
}
