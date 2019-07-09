# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Module for decoding audio files using whichever backend is available"
HOMEPAGE="https://pypi.org/project/audioread/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( dev-python/pymad media-video/ffmpeg )"

PATCHES=(
	"${FILESDIR}/0001-Use-the-print-function-instead-of-the-print-keyword.patch"
	)

pkg_postinst() {
		einfo "You might need to enable additional USE flags in backends to"
		einfo "decode some types of audio files. Priority of backends:"
		einfo "   * mad"
		einfo "   * ffmpeg"
}
