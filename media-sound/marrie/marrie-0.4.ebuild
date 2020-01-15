# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7} )

GIT_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}.git"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="A simple podcast client that runs on the Command Line Interface"
HOMEPAGE="https://github.com/rafaelmartins/marrie"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

pkg_postinst() {
	distutils-r1_pkg_postinst
	elog
	elog "You'll need a media player and a file downloader."
	elog "Recommended packages: net-misc/wget and media-video/mpv"
	elog
}
