# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit libtool linux-info multilib-minimal

MY_P="v4l-utils-${PV}"

DESCRIPTION="Separate libraries ebuild from upstream v4l-utils package"
HOMEPAGE="https://git.linuxtv.org/v4l-utils.git"
SRC_URI="https://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="jpeg"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0=[${MULTILIB_USEDEP}] )
	!elibc_glibc? ( sys-libs/argp-standalone )
	virtual/libudev[${MULTILIB_USEDEP}]
	!media-tv/v4l2-ctl
	!<media-tv/ivtv-utils-1.4.0-r2"
DEPEND="${RDEPEND}
	virtual/os-headers
"
BDEPEND="virtual/pkgconfig
	sys-devel/gettext"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-1.16.6-gcc10-fno-common.patch )

pkg_setup() {
	CONFIG_CHECK="~SHMEM"
	linux-info_pkg_setup
}

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	# Hard disable the flags that apply only to the utils.
	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-qv4l2 \
		--disable-qvidcap \
		--disable-v4l-utils \
		$(use_with jpeg)
}

multilib_src_compile() {
	emake -C lib
}

multilib_src_install() {
	emake -j1 -C lib DESTDIR="${D}" install
}

multilib_src_install_all() {
	dodoc ChangeLog README.lib* TODO
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
