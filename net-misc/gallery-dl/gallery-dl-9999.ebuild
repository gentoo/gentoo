# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7..9})
PYTHON_REQ_USE="sqlite,ssl,xml"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

DESCRIPTION="Download image galleries and collections from several image hosting sites"
HOMEPAGE="https://github.com/mikf/gallery-dl"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mikf/${PN}.git"
else
	SRC_URI="https://github.com/mikf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

# tests require network access
RESTRICT="test"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=">=dev-python/requests-2.11.0[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

src_compile() {
	emake data/completion/gallery-dl
	emake data/completion/_gallery-dl
	emake man
	distutils-r1_src_compile
}

pkg_postinst() {
	elog "To get additional features, some optional runtime dependencies"
	elog "may be installed:"
	elog ""
	optfeature "Pixiv Ugoira to WebM conversion" media-video/ffmpeg
	optfeature "video downloads" net-misc/youtube-dl
}
