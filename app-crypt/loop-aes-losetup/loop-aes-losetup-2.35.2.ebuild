# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs flag-o-matic

MY_PV="${PV/_/-}"
MY_P="util-linux-${MY_PV}"
LOOPAES_P="loop-AES-v3.7q"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Loop-AES losetup utility"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/"
SRC_URI="https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz
	http://loop-aes.sourceforge.net/loop-AES/${LOOPAES_P}.tar.bz2"
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
	eautoreconf
}

lfs_fallocate_test() {
	# Make sure we can use fallocate with LFS #300307
	cat <<-EOF > "${T}"/fallocate.${ABI}.c || die
		#define _GNU_SOURCE
		#include <fcntl.h>
		main() { return fallocate(0, 0, 0, 0); }
	EOF
	append-lfs-flags
	$( $(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${T}"/fallocate.${ABI}.c -o /dev/null >/dev/null 2>&1 || die) \
		|| export ac_cv_func_fallocate=no
	rm "${T}"/fallocate.${ABI}.c || die
}

src_configure() {
	lfs_fallocate_test
	# The scanf test in a run-time test which fails while cross-compiling.
	# Blindly assume a POSIX setup since we require libmount, and libmount
	# itself fails when the scanf test fails. #531856
	tc-is-cross-compiler && export scanf_cv_alloc_modifier=ms

	ECONF_SOURCE=${S} \
	econf \
		--disable-all-programs \
		--disable-pylibmount \
		--enable-libsmartcols \
		--enable-losetup \
		--without-ncurses \
		--without-udev \
		$(use_enable nls) \
		$(use_with selinux) \
		$(tc-has-tls || echo --disable-tls) \
		$(use static && echo --enable-static-programs=losetup)
}

src_install() {
	emake install DESTDIR="${T}/root"
	newsbin "${T}/root/sbin/losetup" loop-aes-losetup
	newman "${T}/root/usr/share/man/man8/losetup.8" loop-aes-losetup.8
	use static && newsbin "${T}/root/bin/losetup.static" loop-aes-losetup.static
}
