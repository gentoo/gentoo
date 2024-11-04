# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..13} )
inherit bash-completion-r1 distutils-r1 git-r3 optfeature wrapper

DESCRIPTION="youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp/"
EGIT_REPO_URI="https://github.com/yt-dlp/yt-dlp.git"

LICENSE="Unlicense"
SLOT="0"
IUSE="man"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	!net-misc/youtube-dl[-yt-dlp(-)]
"
BDEPEND="
	man? ( virtual/pandoc )
"

distutils_enable_tests pytest

python_compile() {
	# generate missing files in live, not in compile_all nor prepare
	# given need lazy before compile and it needs a usable ${PYTHON}
	emake completions lazy-extractors $(usev man yt-dlp.1)

	"${EPYTHON}" devscripts/update-version.py || die

	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_DESELECT=(
		# fails with FEATURES=network-sandbox
		test/test_networking.py::TestHTTPRequestHandler::test_connect_timeout
		# fails with FEATURES=distcc, bug #915614
		test/test_networking.py::TestYoutubeDLNetworking::test_proxy\[None-expected2\]
	)

	epytest -m 'not download'
}

python_install_all() {
	dodoc README.md Changelog.md supportedsites.md
	use man && doman yt-dlp.1

	dobashcomp completions/bash/yt-dlp

	insinto /usr/share/fish/vendor_completions.d
	doins completions/fish/yt-dlp.fish

	insinto /usr/share/zsh/site-functions
	doins completions/zsh/_yt-dlp

	make_wrapper youtube-dl "yt-dlp --compat-options youtube-dl"
}

pkg_postinst() {
	optfeature "various features (merging tracks, streamed content)" media-video/ffmpeg
	has_version media-video/atomicparsley || # allow fallback but don't advertise
		optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen
	optfeature "decrypting cookies from Chromium-based browsers" dev-python/secretstorage

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog 'A wrapper using "yt-dlp --compat-options youtube-dl" was installed'
		elog 'as "youtube-dl". This is strictly for compatibility and it is'
		elog 'recommended to use "yt-dlp" directly, it may be removed in the future.'
	fi
}
