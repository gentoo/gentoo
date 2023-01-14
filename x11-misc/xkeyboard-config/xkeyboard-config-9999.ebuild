# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit meson python-any-r1

DESCRIPTION="X keyboard configuration database"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"
	inherit git-r3
else
	SRC_URI="https://www.x.org/releases/individual/data/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
fi

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND=""
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	dev-libs/libxslt
	sys-devel/gettext
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dxkb-base="${EPREFIX}/usr/share/X11/xkb"
		-Dcompat-rules=true
	)
	meson_src_configure
}
