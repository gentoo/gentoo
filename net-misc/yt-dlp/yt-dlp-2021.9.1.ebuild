# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1 readme.gentoo-r1

DESCRIPTION="A youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~riscv ~x86"
LICENSE="public-domain"
SLOT="0"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	media-video/ffmpeg

"

distutils_enable_tests nose

python_test() {
	# make_lazy_extractors.py tries to rename it out, so fails if it does not exists.
	mkdir ytdlp_plugins
	epytest -k 'not download'
}

python_install_all() {
	doman yt-dlp.1

	newbashcomp completions/bash/yt-dlp yt-dlp

	insinto /usr/share/zsh/site-functions
	newins completions/zsh/_yt-dlp _yt-dlp

	insinto /usr/share/fish/vendor_completions.d
	doins completions/fish/yt-dlp.fish

	distutils-r1_python_install_all

	rm -rf "${ED}"/usr/share/doc/yt_dlp || die
}
