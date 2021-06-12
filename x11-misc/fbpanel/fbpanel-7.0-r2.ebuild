# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="light-weight X11 desktop panel"
HOMEPAGE="https://aanatoly.github.io/fbpanel/"
SRC_URI="https://aanatoly.github.io/fbpanel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ppc ppc64 x86"
IUSE="alsa"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1-underlinking.patch
	"${FILESDIR}"/${PN}-7.0-clang.patch
	"${FILESDIR}"/${PN}-7.0-fno-common.patch
	"${FILESDIR}"/${PN}-7.0-images.patch
	"${FILESDIR}"/${PN}-7.0-python3-shebangs.patch
	"${FILESDIR}"/${PN}-7.0-remove-gdk-pixbuf-xlib.h.patch
)

src_prepare() {
	default
	2to3 -n -w --no-diffs configure .config/*.py || die
}

src_configure() {
	tc-export CC
	# not autotools based
	local myconfigure=(
		./configure V=1
		--mandir="${EPREFIX}"/usr/share/man/man1
		--datadir="${EPREFIX}"/usr/share/${PN}
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN}
		$(usex alsa --sound --no-sound)
	)
	echo ${myconfigure[@]} || die
	${myconfigure[@]} || die
}

pkg_postinst() {
	elog "For the volume plugin to work, you need to configure your kernel"
	elog "with CONFIG_SND_MIXER_OSS or CONFIG_SOUND_PRIME or some other means"
	elog "that provide the /dev/mixer device node."
}
