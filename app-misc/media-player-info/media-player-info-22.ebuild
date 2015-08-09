# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit eutils python-any-r1

DESCRIPTION="A repository of data files describing media player capabilities"
HOMEPAGE="http://cgit.freedesktop.org/media-player-info/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

# http://cgit.freedesktop.org/media-player-info/commit/?id=d83dd01a0a1df6198ee08954da1c033b88a1004b
RDEPEND=">=virtual/udev-208"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

pkg_postinst() {
	# Run for /lib/udev/hwdb.d/20-usb-media-players.hwdb
	udevadm hwdb --update --root="${ROOT%/}"
	# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
	if [[ ${ROOT} != "" ]] && [[ ${ROOT} != "/" ]]; then
		return 0
	fi
	udevadm control --reload
}
