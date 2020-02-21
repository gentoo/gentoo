# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit autotools python-single-r1

MY_PN=AFFLIBv3
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library that implements the AFF image standard"
HOMEPAGE="https://github.com/sshock/AFFLIBv3/"
SRC_URI="https://github.com/sshock/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc x86 ~x64-macos"
IUSE="fuse libressl ncurses python qemu readline s3 static-libs threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/expat
	sys-libs/zlib:0=
	fuse? ( sys-fs/fuse:= )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	ncurses? ( sys-libs/ncurses:0= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	s3? ( net-misc/curl )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i '/FLAGS/s: -g::' configure.ac || die

	default
	eautoreconf
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
		$(use_enable static-libs static)
		$(use_enable threads threading)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
