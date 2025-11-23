# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
EPYTEST_XDIST=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Portable archive file manager"
HOMEPAGE="https://wummel.github.io/patool/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	test? (
		app-arch/7zip
		app-arch/arj
		app-arch/bzip2
		app-arch/bzip3
		app-arch/cabextract
		app-alternatives/cpio
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
		app-arch/zopfli
		app-arch/zpaq
		app-arch/zstd
		app-cdr/cdrtools
		dev-libs/chmlib
		media-libs/flac
		media-sound/shorten
		sys-apps/diffutils
		sys-apps/file
		sys-apps/grep
		|| (
			>=app-arch/7zip-24.09[symlink(+)]
			app-arch/p7zip
		)
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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Unpackaged and just wraps setuptools with SOURCE_DATE_EPOCH
	sed -e 's/setuptools-reproducible/setuptools/' \
		-e 's/setuptools_reproducible/setuptools.build_meta/' \
		-i pyproject.toml || die
}

python_install_all() {
	einstalldocs
	doman doc/patool.1
	distutils-r1_python_install_all
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
	)
	local EPYTEST_DESELECT=(
		# Something changed in the upstream sdist creation between 4.0.0 and 4.0.1
		# Test fails because the timestamp of the zip arhive is before 1980.
		# This is due to the timestamps getting reset to the unix epoch in
		# the unpacked tar archive.
		# ValueError: ZIP does not support timestamps before 1980
		"tests/archives/test_pyzipfile.py::TestPyzipfile::test_py_zipfile"
	)

	if use elibc_musl; then
		EPYTEST_IGNORE+=(
			"tests/archives/test_rar.py"
		)
	fi

	if use x86; then
		EPYTEST_IGNORE+=(
			"tests/archives/test_clzip.py"
		)
		EPYTEST_DESELECT+=(
			# bug #916317
			"tests/archives/test_lrzip.py::TestLrzip::test_lrzip"
		)
	fi

	epytest
}
