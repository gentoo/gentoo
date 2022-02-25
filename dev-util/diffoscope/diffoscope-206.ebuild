# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="ncurses"
inherit distutils-r1

DESCRIPTION="Will try to get to the bottom of what makes files or directories different"
HOMEPAGE="https://diffoscope.org/ https://pypi.org/project/diffoscope/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="acl binutils bzip2 libcaca colord cpio +diff docx dtc e2fsprogs file
find gettext gif gpg haskell hdf5 hex imagemagick iso java llvm lzma
mono opendocument pascal pdf postscript R rpm sqlite squashfs
ssh tar test tcpdump zip zlib zstd"

RESTRICT="!test? ( test )"

# pull in optional tools for tests:
# img2txt: bug #797688
# docx2txt: bug #797688
BDEPEND="test? (
		app-text/docx2txt
		media-libs/libcaca
		virtual/imagemagick-tools[jpeg]
	)"
RDEPEND="dev-python/python-magic[${PYTHON_USEDEP}]
	dev-python/libarchive-c[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
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
		dev-python/PyPDF2[${PYTHON_USEDEP}]
	)
	postscript? ( app-text/ghostscript-gpl )
	R? ( dev-lang/R )
	rpm? ( app-arch/rpm )
	sqlite? ( dev-db/sqlite:3 )
	squashfs? ( sys-fs/squashfs-tools )
	ssh? ( net-misc/openssh )
	tar? ( app-arch/tar )
	tcpdump? ( net-analyzer/tcpdump )
	zip? ( app-arch/unzip )
	zlib? ( app-arch/gzip )
	zstd? ( app-arch/zstd )
"
# Presence if filemagic's magic.py breaks imports
# of dev-python/python-magic: https://bugs.gentoo.org/716482
RDEPEND+=" !dev-python/filemagic"

EPYTEST_DESELECT=(
	# Test seems to use different tarball
	tests/test_presenters.py::test_text_proper_indentation

	# Needs triage
	tests/comparators/test_binary.py::test_with_compare_details_and_tool_not_found
	tests/comparators/test_rlib.py::test_item3_deflate_llvm_bitcode

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
)

distutils_enable_tests pytest
