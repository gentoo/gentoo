# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="External JavaScript for yt-dlp supporting many runtimes"
HOMEPAGE="https://github.com/yt-dlp/ejs/"
# wheel for .js files, github's assets also has them but uncompressed
SRC_URI+=" $(pypi_wheel_url --unpack)"

LICENSE="Unlicense"
LICENSE+=" ISC MIT" # .js dependencies
SLOT="0"
# bumps should typically be done straight-to-stable like yt-dlp itself
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

BDEPEND="
	app-arch/unzip
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

# this only tests basic python bits without javascript to avoid headaches
distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# drop deno/npm calls and use pre-generated .js instead, this
	# both prevents network use and ensures no hash mismatch given
	# yt-dlp checks the sha512sum of the .js files
	sed -i '/wheel.hooks.custom/,/^$/d' pyproject.toml || die
	mv ../yt_dlp_ejs/yt/solver/*.js yt_dlp_ejs/yt/solver/ || die
}
