# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit python-any-r1

DESCRIPTION="Repository of data files describing media player capabilities"
HOMEPAGE="https://gitlab.freedesktop.org/media-player-info/media-player-info"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

# Upstream commit d83dd01a0a1df6198ee08954da1c033b88a1004b
RDEPEND=">=virtual/udev-208"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

DOCS=( AUTHORS NEWS )

pkg_postinst() {
	# Run for /lib/udev/hwdb.d/20-usb-media-players.hwdb
	udevadm hwdb --update --root="${ROOT}"
	# Upstream commit 1fab57c209035f7e66198343074e9cee06718bda
	if [[ ${ROOT} != "" ]] && [[ ${ROOT} != "/" ]]; then
		return 0
	fi
	udevadm control --reload
}
