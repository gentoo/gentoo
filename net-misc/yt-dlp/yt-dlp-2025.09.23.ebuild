# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
inherit distutils-r1 optfeature shell-completion wrapper

DESCRIPTION="youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp/"
SRC_URI="
	https://github.com/yt-dlp/yt-dlp/releases/download/${PV}/${PN}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}

LICENSE="Unlicense"
SLOT="0"
# note that yt-dlp bumps are typically done straight-to-stable (unless there
# was major/breaking changes) given website changes breaks it on a whim
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( media-video/ffmpeg[webp] )
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# fails with FEATURES=network-sandbox
		test/test_networking.py::TestHTTPRequestHandler::test_connect_timeout
		# fails with FEATURES=distcc, bug #915614
		test/test_networking.py::TestYoutubeDLNetworking::test_proxy\[None-expected2\]
		# websockets tests break easily depending on dev-python/websockets
		# version and, as far as I know, most users do not use/need it --
		# thus being neither in RDEPEND nor optfeature (bug #940630,#950030)
		test/test_websockets.py
	)

	epytest -m 'not download'
}

python_install_all() {
	dodoc README.md Changelog.md supportedsites.md
	doman yt-dlp.1

	dobashcomp completions/bash/yt-dlp
	dofishcomp completions/fish/yt-dlp.fish
	dozshcomp completions/zsh/_yt-dlp

	rm -r "${ED}"/usr/share/doc/yt_dlp || die

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
