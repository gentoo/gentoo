# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1

DESCRIPTION="youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/websockets[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-video/ffmpeg"

distutils_enable_tests pytest

python_test() {
	epytest -m 'not download'
}

python_install_all() {
	dodoc README.md Changelog.md supportedsites.md
	doman yt-dlp.1

	dobashcomp completions/bash/yt-dlp

	insinto /usr/share/fish/vendor_completions.d
	doins completions/fish/yt-dlp.fish

	insinto /usr/share/zsh/site-functions
	doins completions/zsh/_yt-dlp

	rm -r "${ED}"/usr/share/doc/yt_dlp || die
}
