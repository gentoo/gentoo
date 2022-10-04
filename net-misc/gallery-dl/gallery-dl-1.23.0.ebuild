# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite,ssl,xml(+)"

inherit distutils-r1 optfeature

DESCRIPTION="Download image galleries and collections from several image hosting sites"
HOMEPAGE="https://github.com/mikf/gallery-dl"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mikf/${PN}.git"
else
	SRC_URI="https://github.com/mikf/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
# tests require network access
RESTRICT="test"

RDEPEND=">=dev-python/requests-2.11.0[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

python_compile_all() {
	emake PYTHON=${EPYTHON} data/completion/{,_}gallery-dl man
}

pkg_postinst() {
	optfeature "Pixiv Ugoira to WebM conversion" media-video/ffmpeg
	optfeature "video downloads" net-misc/youtube-dl
}
