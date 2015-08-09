# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Module for decoding audio files using whichever backend is available"
HOMEPAGE="http://pypi.python.org/pypi/audioread"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( dev-python/gst-python:0.10[${PYTHON_USEDEP}] dev-python/pymad media-video/ffmpeg )"

PATCHES=(
	"${FILESDIR}/0001-Use-the-print-function-instead-of-the-print-keyword.patch"
	)

pkg_postinst() {
		elog "You might need to enable additional USE flags in backends to"
		elog "decode some types of audio files. Priority of backends:"
		elog "   * gstreamer"
		elog "   * mad"
		elog "   * ffmpeg"
}
