# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs libtool flag-o-matic

MY_PV="${PV/_/-}"
MY_P="util-linux-${MY_PV}"
LOOPAES_P="loop-AES-v3.8b"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Loop-AES losetup utility"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/ https://github.com/util-linux/util-linux"
SRC_URI="https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz
	https://loop-aes.sourceforge.net/loop-AES/${LOOPAES_P}.tar.bz2"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"

LICENSE="GPL-2 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
IUSE="nls selinux static"

RDEPEND="selinux? ( >=sys-libs/libselinux-2.2.2-r4 )"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${WORKDIR}/${LOOPAES_P}/util-linux-${PV}.diff"
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	append-lfs-flags

	# The scanf test in a run-time test which fails while cross-compiling.
	# Blindly assume a POSIX setup since we require libmount, and libmount
	# itself fails when the scanf test fails. #531856
	tc-is-cross-compiler && export scanf_cv_alloc_modifier=ms

	ECONF_SOURCE=${S} \
	econf \
		--disable-all-programs \
		--disable-libmount-mountfd-support \
		--disable-pylibmount \
		--enable-libsmartcols \
		--enable-losetup \
		--without-ncurses \
		--without-udev \
		$(use_enable nls) \
		$(use_with selinux) \
		$(tc-has-tls || echo --disable-tls) \
		$(use_enable static) \
		$(use static && echo --enable-static-programs=losetup)
}

src_install() {
	emake install DESTDIR="${T}/root"
	newsbin "${T}/root/sbin/losetup" loop-aes-losetup
	newman "${T}/root/usr/share/man/man8/losetup.8" loop-aes-losetup.8
	use static && newsbin "${T}/root/bin/losetup.static" loop-aes-losetup.static
}
