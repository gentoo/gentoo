# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="External JavaScript for yt-dlp supporting many runtimes"
HOMEPAGE="https://github.com/yt-dlp/ejs/"
SRC_URI+=" $(pypi_wheel_url --unpack)"

LICENSE="Unlicense"
LICENSE+=" ISC MIT" # .js dependencies
SLOT="0"
# in-sync with yt-dlp and always straight-to-stable like yt-dlp itself
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"
# tests do not use python and are troublesome due to javascript, if in
# doubt try downloading a youtube video with yt-dlp as a basic test
RESTRICT="test"

BDEPEND="
	app-arch/unzip
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare

	# drop deno/npm calls and use the pre-generated .js from the .whl
	# instead, this both prevent network use and ensures no hash
	# mismatch given yt-dlp checks the sha512sum of the .js files
	# (makes generating our own meaningless given can't be patched)
	sed -i '/wheel.hooks.custom/d' pyproject.toml || die
	mv ../yt_dlp_ejs/yt/solver/*.js yt_dlp_ejs/yt/solver/ || die
}
