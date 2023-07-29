# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# No 3.12 yet as these two tests fail:
# ERROR tests/comparators/test_elf.py::test_differences_with_dbgsym - TypeError: sequence item 1: expected str instance, bytes found
# ERROR tests/comparators/test_elf.py::test_original_gnu_debuglink - TypeError: sequence item 1: expected str instance, bytes found
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="ncurses"
inherit distutils-r1

DESCRIPTION="Will try to get to the bottom of what makes files or directories different"
HOMEPAGE="https://diffoscope.org/ https://pypi.org/project/diffoscope/"
# We could use pypi, but upstream provide distribution tarballs, so let's use those.
# TODO: verify-sig
SRC_URI="https://diffoscope.org/archive/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~x86"
IUSE="acl binutils bzip2 libcaca colord cpio +diff docx dtc e2fsprogs file
find gettext gif gpg haskell hdf5 hex imagemagick iso java llvm lzma
mono opendocument pascal pdf postscript R rpm sqlite squashfs
ssh tar test tcpdump zip zlib zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/libarchive-c[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/tlsh[${PYTHON_USEDEP}]
	acl? ( sys-apps/acl )
	binutils? ( sys-devel/binutils )
	bzip2? ( app-arch/bzip2 )
	libcaca? ( media-libs/libcaca )
	colord? ( x11-misc/colord )
	cpio? ( app-arch/cpio )
	diff? ( sys-apps/diffutils )
	docx? ( app-text/docx2txt )
	dtc? ( sys-apps/dtc )
	e2fsprogs? ( sys-fs/e2fsprogs )
	file? ( sys-apps/file )
	find? ( sys-apps/findutils )
	gettext? ( sys-devel/gettext )
	gif? ( media-libs/giflib )
	gpg? ( app-crypt/gnupg )
	haskell? ( dev-lang/ghc )
	hdf5? ( sci-libs/hdf5 )
	hex? ( app-editors/vim-core )
	imagemagick? ( media-gfx/imagemagick )
	iso? ( app-cdr/cdrtools )
	java? ( virtual/jdk )
	llvm? ( sys-devel/llvm )
	lzma? ( app-arch/xz-utils )
	mono? ( dev-lang/mono )
	opendocument? ( app-text/odt2txt )
	pascal? ( dev-lang/fpc )
	pdf? (
		app-text/pdftk
		app-text/poppler
		dev-python/pypdf[${PYTHON_USEDEP}]
	)
	postscript? ( app-text/ghostscript-gpl )
	R? ( dev-lang/R )
	rpm? ( app-arch/rpm )
	sqlite? ( dev-db/sqlite:3 )
	squashfs? ( sys-fs/squashfs-tools )
	ssh? ( virtual/openssh )
	tar? ( app-arch/tar )
	tcpdump? ( net-analyzer/tcpdump )
	zip? ( app-arch/unzip )
	zlib? ( app-arch/gzip )
	zstd? ( app-arch/zstd )
"
# Presence of filemagic's magic.py breaks imports
# of dev-python/python-magic: bug #716482
RDEPEND+=" !dev-python/filemagic"

# pull in optional tools for tests:
# img2txt: bug #797688
# docx2txt: bug #797688
BDEPEND="
	test? (
		app-text/docx2txt
		app-text/html2text
		media-libs/libcaca
		virtual/imagemagick-tools[jpeg]
	)
"

EPYTEST_DESELECT=(
	# Test seems to use different tarball
	tests/test_presenters.py::test_text_proper_indentation

	# Needs triage
	tests/comparators/test_binary.py::test_with_compare_details_and_tool_not_found
	tests/comparators/test_rlib.py::test_item3_deflate_llvm_bitcode
	tests/comparators/test_gif.py::test_has_visuals

	# img2txt based failures, bug #797688
	tests/comparators/test_ico_image.py::test_diff
	tests/comparators/test_ico_image.py::test_diff_meta
	tests/comparators/test_ico_image.py::test_diff_meta2
	tests/comparators/test_ico_image.py::test_has_visuals
	tests/comparators/test_jpeg_image.py::test_diff
	tests/comparators/test_jpeg_image.py::test_compare_non_existing
	tests/comparators/test_jpeg_image.py::test_diff_meta
	tests/comparators/test_jpeg_image.py::test_has_visuals

	# docx2txt based falures, bug #797688
	tests/comparators/test_docx.py::test_diff

	# Formatting
	tests/test_source.py::test_code_is_black_clean

	# Fails on ZFS
	tests/test_main.py::test_non_unicode_filename

	# Fails on (unreleased) LLVM 16 with minor difference
	tests/comparators/test_macho.py::test_llvm_diff
	tests/comparators/test_elf.py::test_libmix_differences
)

distutils_enable_tests pytest
