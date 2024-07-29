# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite,ssl,xml(+)"

inherit distutils-r1 optfeature

DESCRIPTION="Download image galleries and collections from several image hosting sites"
HOMEPAGE="https://github.com/mikf/gallery-dl/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/mikf/${PN}.git"
else
	SRC_URI="
		https://github.com/mikf/${PN}/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
		https://github.com/mikf/${PN}/commit/5227bb6b1d62ecef5b281592b0d001e7f9c101e3.patch
			-> ${P}-5227bb6.patch
	"

	KEYWORDS="amd64 arm arm64 hppa ppc ppc64 ~riscv x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
"

PATCHES=( "${DISTDIR}/${P}-5227bb6.patch" )

distutils_enable_tests unittest

src_prepare() {
	# Tests against real servers, some tests always fail and some are subject to change.
	rm test/test_results.py || die

	distutils-r1_src_prepare
}

python_compile_all() {
	emake PYTHON="${EPYTHON}" data/completion/{,_}gallery-dl man
}

pkg_postinst() {
	optfeature "Pixiv Ugoira to WebM conversion" media-video/ffmpeg
	optfeature "video downloads" net-misc/yt-dlp
}
