# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A simple podcast client that runs on the Command Line Interface"
HOMEPAGE="https://github.com/rafaelmartins/marrie"

LICENSE="BSD"
SLOT="0"

RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"

pkg_postinst() {
	elog
	elog "You'll need a media player and a file downloader."
	elog "Recommended packages: net-misc/wget and media-video/mpv"
	elog
}
