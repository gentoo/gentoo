# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Portable archive file manager"
HOMEPAGE="https://wummel.github.io/patool/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	test? (
		app-arch/arj
		app-arch/bzip2
		app-arch/bzip3
		app-arch/cabextract
		app-arch/cpio
		app-arch/dpkg
		app-arch/gzip
		app-arch/lbzip2
		app-arch/lcab
		app-arch/lha
		app-arch/libarchive
		app-arch/lz4
		app-arch/lzip
		app-arch/lzop
		app-arch/ncompress
		app-arch/p7zip[rar]
		app-arch/pbzip2
		app-arch/pdlzip
		app-arch/pigz
		app-arch/plzip
		app-arch/rpm
		app-arch/rzip
		app-arch/sharutils
		app-arch/tar
		app-arch/unace
		app-arch/unadf
		app-arch/unzip
		app-arch/xdms
		app-arch/xz-utils
		app-arch/zip
		app-arch/zpaq
		app-arch/zstd
		app-cdr/cdrtools
		dev-libs/chmlib
		media-libs/flac
		media-sound/shorten
		sys-apps/diffutils
		sys-apps/file
		sys-apps/grep
		!elibc_musl? ( app-arch/rar )
		!x86? (
			app-arch/clzip
			app-arch/lrzip
			app-arch/unar
		)
	)
"
# Test dependencies which are packaged but can't be tested for various reasons.
# app-arch/arc
# app-arch/zoo
# app-arch/zopfli
# media-sound/mac

# app-arch/rar is masked on musl
# app-arch/clzip is unkeyworded on x86
# app-arch/lrzip bug #916317 on x86
# app-arch/unar is unkeyworded on x86

# Unpackaged testable dependencies
# archmage
# genisoimage
# lhasa
# nomarch
# pdzip2
# py_{bz2,echo,gzip,tarfile,zipfile}
# rpm2cpio
# rzip
# star
# unalz
# uncompress.real

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	newdoc doc/README.txt README.md
	doman doc/patool.1
}

python_test() {
	local EPYTEST_IGNORE=(
		# zoo emits a non-zero exit status on a possibly false consistency check
		# Zoo:  WARNING:  Archive header failed consistency check.
		"tests/archives/test_zoo.py"
		# Doesn't accept long arguments, such as those that files in ${S} would have.
		# Too long argument: /var/tmp/portage/app-arch/patool-1.12_p20230424/work/patool-ab64562c8cdac34dfd69fcb6e30c8c0014282d11/tests/data/p.arc.foo
		"tests/archives/test_arc.py"
		# Error: 1002 (invalid input file)
		"tests/archives/test_mac.py"
		# AttributeError: module 'patoolib.programs.zopfli' has no attribute 'extract_gzip'
		"tests/archives/test_zopfli.py"
	)

	if use elibc_musl; then
		EPYTEST_IGNORE+=(
			"tests/archives/test_rar.py"
		)
	fi

	if use x86; then
		EPYTEST_IGNORE+=(
			"tests/archives/test_clzip.py"
			# bug #916317
			"tests/archives/test_lrzip.py::TestLrzip::test_lrzip"
		)
	fi

	epytest
}
