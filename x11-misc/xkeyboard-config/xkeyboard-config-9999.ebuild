# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af ar az bg ca crh cs da de el en_GB eo es fi fr fur gl he hr hu id it ja ka ko ky lt nb nl pl pt pt_BR ro ru rw sk sl sq sr sv tr uk vi zh_CN zh_TW"

PYTHON_COMPAT=( python3_{10..12} )
inherit meson python-any-r1 plocale

DESCRIPTION="X keyboard configuration database"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"
	inherit git-r3
else
	SRC_URI="https://www.x.org/releases/individual/data/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="MIT"
SLOT="0"
IUSE="man"

DEPEND=""
RDEPEND=""
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	man? ( dev-libs/libxslt )
	sys-devel/gettext
"

src_prepare() {
	default
	plocale_get_locales > po/LINGUAS || die
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	if ! use man; then
		# Make sure xslt is disabled
		sed -i -e 's/if xsltproc\.found()/if false/' 'meson.build'
	fi
	# Make sure pytest is disabled
	sed -i -e 's/if enable_pytest/if false/' 'meson.build'
	local emesonargs=(
		-Dxkb-base="${EPREFIX}/usr/share/X11/xkb"
		-Dcompat-rules=true
	)
	meson_src_configure
}
