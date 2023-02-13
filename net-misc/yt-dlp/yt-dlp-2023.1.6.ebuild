# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )
inherit bash-completion-r1 distutils-r1 optfeature pypi wrapper

DESCRIPTION="youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp/"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv x86 ~x64-macos"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	!net-misc/youtube-dl[-yt-dlp(-)]"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# adjust requires for pycryptodome and optional dependencies (bug #828466)
	sed -ri requirements.txt \
		-e "s/^(pycryptodome)x/\1/" \
		-e "/^(brotli.*|certifi|mutagen|websockets)/d" || die
}

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

	make_wrapper youtube-dl "yt-dlp --compat-options youtube-dl"
}

pkg_postinst() {
	optfeature "various features (merging tracks, streamed content)" media-video/ffmpeg
	has_version media-video/atomicparsley || # allow fallback but don't advertise
		optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog 'A wrapper using "yt-dlp --compat-options youtube-dl" was installed'
		elog 'as "youtube-dl". This is strictly for compatibility and it is'
		elog 'recommended to use "yt-dlp" directly, it may be removed in the future.'
	fi
}
