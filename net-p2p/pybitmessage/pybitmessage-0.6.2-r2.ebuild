# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

# See https://github.com/Bitmessage/PyBitmessage/pull/952 for
# why ipv6 is needed at the moment.
PYTHON_REQ_USE="ipv6,sqlite"

inherit distutils-r1 gnome2-utils

MY_PN="PyBitmessage"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="P2P communications protocol"
HOMEPAGE="https://bitmessage.org/"
SRC_URI="https://github.com/Bitmessage/${MY_PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl ncurses opencl sound"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"

# Some of these can be determined from src/depends.py.
# The sound deps were found in src/bitmessageqt/__init__.py.
# And src/openclpow.py imports numpy directly, so throw that in too.
#
# All of the dependencies that are behind USE flags are detected
# and enabled automagically, so maybe it would be better if we
# required them unconditionally?
RDEPEND="${DEPEND}
	dev-python/msgpack[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )
	ncurses? ( dev-python/pythondialog[${PYTHON_USEDEP}] )
	opencl? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyopencl[${PYTHON_USEDEP}]
	)
	sound? ( || (
		media-sound/gst123
		media-sound/alsa-utils
		media-sound/mpg123
	) )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/noninteractive-build.patch")

src_install () {
	distutils-r1_src_install
	dodoc README.md

	# The man page is not installed because it's basically empty.
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
