# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-any-r1 udev

DESCRIPTION="Repository of data files describing media player capabilities"
HOMEPAGE="https://gitlab.freedesktop.org/media-player-info/media-player-info"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# This ebuild does not install any binaries
RESTRICT="
	binchecks strip
	!test? ( test )
"

# Upstream commit d83dd01a0a1df6198ee08954da1c033b88a1004b
RDEPEND=">=virtual/udev-208"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( dev-libs/appstream )
"

DOCS=( AUTHORS NEWS )

src_unpack() {
	default
	mv "${WORKDIR}"/media-player-info-${PV}-*/ "${WORKDIR}"/media-player-info-${PV} || die
}

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
	udev_reload
	udev_hwdb_update
}

pkg_postrm() {
	udev_reload
	udev_hwdb_update
}
