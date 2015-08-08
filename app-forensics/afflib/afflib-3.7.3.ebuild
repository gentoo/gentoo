# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

inherit autotools-utils python-single-r1

MY_PN=AFFLIBv3
MY_P=${MY_PN}-${PV}

DESCRIPTION="Library that implements the AFF image standard"
HOMEPAGE="https://github.com/simsong/AFFLIBv3/"
SRC_URI="https://github.com/simsong/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="fuse ncurses python qemu readline s3 static-libs threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/expat
	dev-libs/openssl:0
	sys-libs/zlib
	fuse? ( sys-fs/fuse )
	ncurses? ( sys-libs/ncurses )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0 )
	s3? ( net-misc/curl )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.7.1-python-module.patch
	"${FILESDIR}"/${PN}-3.6.12-pyaff-header.patch
)

S=${WORKDIR}/${MY_P}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i '/FLAGS/s: -g::' configure.ac || die
	sed -i '/-static/d' tools/Makefile.am || die

	autotools-utils_src_prepare
}

src_configure() {
	# Hacks for automagic dependencies
	use ncurses || export ac_cv_lib_ncurses_initscr=no
	use readline || export ac_cv_lib_readline_readline=no

	local myeconfargs=(
		$(use_enable fuse)
		$(use_enable python)
		$(use_enable qemu)
		$(use_enable s3)
		$(use_enable threads threading)
	)
	autotools-utils_src_configure
}
