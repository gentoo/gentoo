# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}-3.0-${PV}
DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="https://github.com/kupferlauncher/keybinder"
SRC_URI="https://github.com/kupferlauncher/keybinder/releases/download/${PN}-3.0-v${PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv x86"
IUSE="+introspection"

RDEPEND="x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )"

src_configure() {
	local myconf=(
		$(use_enable introspection)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	# remove old symlink as otherwise the files will be installed
	# in the wrong directory
	if [[ -h ${EROOT}/usr/share/gtk-doc/html/keybinder-3.0 ]]; then
		rm "${EROOT}/usr/share/gtk-doc/html/keybinder-3.0" || die
	fi
}
