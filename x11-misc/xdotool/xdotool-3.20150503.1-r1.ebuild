# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic multilib

DESCRIPTION="Simulate keyboard input and mouse activity, move and resize windows"
HOMEPAGE="https://www.semicomplete.com/projects/xdotool/"
SRC_URI="https://github.com/jordansissel/xdotool/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"
IUSE="examples"

RDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libxkbcommon"
DEPEND="${RDEPEND}"

# The test wants to manualy start Xvfb, wont use VirtualX and it tries
# to run a full gnome-session. For such a tiny application i consider
# it overkill to rewrite the test scripts to not use it's own X server
# and add a full blown gnome just to run the tests.
RESTRICT="test"

src_prepare() {
	default
	sed -i \
		-e "s/installheader post-install$/installheader/" \
		-e 's:\<pkg-config\>:$(PKG_CONFIG):' \
		Makefile || die "sed failed"
}

src_compile() {
	tc-export CC LD PKG_CONFIG
	default
}

src_install() {
	emake PREFIX="${D}usr" INSTALLMAN="${D}usr/share/man" INSTALLLIB="${D}usr/$(get_libdir)" install

	dodoc CHANGELIST README
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
