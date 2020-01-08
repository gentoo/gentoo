# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}-3.0-${PV}
DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="https://github.com/kupferlauncher/keybinder"
SRC_URI="https://github.com/kupferlauncher/keybinder/releases/download/${PN}-3.0-v${PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 x86"
IUSE="+introspection"

RDEPEND="x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

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
	if [[ -h ${EROOT%/}/usr/share/gtk-doc/html/keybinder-3.0 ]]; then
		rm "${EROOT%/}/usr/share/gtk-doc/html/keybinder-3.0" || die
	fi
}
