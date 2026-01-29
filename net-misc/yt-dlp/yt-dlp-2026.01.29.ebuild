# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
inherit distutils-r1 optfeature shell-completion wrapper

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/yt-dlp/yt-dlp.git"
else
	SRC_URI="
		https://github.com/yt-dlp/yt-dlp/releases/download/${PV}/${PN}.tar.gz
			-> ${P}.tar.gz
	"
	S=${WORKDIR}/${PN}
	# note that yt-dlp bumps are typically done straight-to-stable (unless some
	# major/breaking changes) given website changes breaks it on a whim
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"
fi

DESCRIPTION="youtube-dl fork with additional features and fixes"
HOMEPAGE="https://github.com/yt-dlp/yt-dlp/"

LICENSE="Unlicense"
SLOT="0"
IUSE="+deno"

# deno is technically a optfeature, but it is needed for proper YouTube
# support and most users would expect that to work out-of-the-box
# (there are alternatives like nodejs but upstream disables support by
# default due to security concerns, users are on their own for these)
#
# yt-dlp-ejs requires pinning due to yt-dlp checking sha512sum of .js,
# live ebuild users may need to use the self-updater method if out of
# sync as there are no plans for a yt-dlp-ejs live ebuild at the moment
# (should "typically" be updated in Gentoo within 24h if willing to wait)
RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	=dev-python/yt-dlp-ejs-0.4*[${PYTHON_USEDEP}]
	deno? ( >=dev-lang/deno-bin-2.6.6 )
"
BDEPEND="
	test? ( media-video/ffmpeg[webp] )
"

if [[ ${PV} == 9999 ]]; then
	IUSE+=" man"
	BDEPEND+=" man? ( virtual/pandoc )"
fi

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	if [[ ${PV} == 9999 ]]; then
		# generate missing files in live, not in compile_all nor prepare
		# given need lazy before compile and it needs a usable ${PYTHON}
		emake completions lazy-extractors $(usev man yt-dlp.1)

		"${EPYTHON}" devscripts/update-version.py || die
	fi

	distutils-r1_python_compile
}

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

	if [[ ${PV} == 9999 ]]; then
		use man && doman yt-dlp.1
	else
		doman yt-dlp.1
		rm -r -- "${ED}"/usr/share/doc/yt_dlp || die
	fi

	dobashcomp completions/bash/yt-dlp
	dofishcomp completions/fish/yt-dlp.fish
	dozshcomp completions/zsh/_yt-dlp

	make_wrapper youtube-dl "yt-dlp --compat-options youtube-dl"
}

pkg_postinst() {
	optfeature "various features (merging tracks, streamed content)" media-video/ffmpeg
	has_version media-video/atomicparsley || # allow fallback but don't advertise
		optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen
	optfeature "decrypting cookies from Chromium-based browsers" dev-python/secretstorage

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog 'A wrapper using "yt-dlp --compat-options youtube-dl" was installed'
		elog 'as "youtube-dl". This is strictly for compatibility and it is'
		elog 'recommended to use "yt-dlp" directly, it may be removed in the future.'
	fi

	if use !deno; then
		ewarn
		ewarn "USE=deno is disabled, using ${PN} with some websites like YouTube may"
		ewarn "not function properly. If your profile does not allow enabling this USE,"
		ewarn "can use net-libs/nodejs instead but it is disabled by default due to"
		ewarn "security(!) concerns and requires manually passing '--js-runtimes node'"
		ewarn "(to be permanent: echo '--js-runtimes node' >> ~/.config/yt-dlp/config)"
	fi
}
