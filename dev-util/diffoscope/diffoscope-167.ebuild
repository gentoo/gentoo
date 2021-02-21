# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE="ncurses"
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Will try to get to the bottom of what makes files or directories different"
HOMEPAGE="https://diffoscope.org/ https://pypi.org/project/diffoscope/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="acl binutils bzip2 libcaca colord cpio +diff docx dtc e2fsprogs file
find gettext gif gpg gzip haskell hdf5 hex imagemagick iso java llvm
mono opendocument pascal pdf postscript R rpm sqlite squashfs
ssh tar tcpdump xz zip zstd"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
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
	gzip? ( app-arch/gzip )
	haskell? ( dev-lang/ghc )
	hdf5? ( sci-libs/hdf5 )
	hex? ( app-editors/vim-core )
	imagemagick? ( media-gfx/imagemagick )
	iso? ( app-cdr/cdrtools )
	java? ( virtual/jdk )
	llvm? ( sys-devel/llvm )
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
	xz? ( app-arch/xz-utils )
	zip? ( app-arch/unzip )
	zstd? ( app-arch/zstd )
"
# Presence if filemagic's magic.py breaks imports
# of dev-python/python-magic: https://bugs.gentoo.org/716482
RDEPEND+=" !dev-python/filemagic"
