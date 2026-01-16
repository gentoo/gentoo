# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jariruusu.asc
UTIL_LINUX_VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/karelzak.asc
inherit autotools flag-o-matic toolchain-funcs verify-sig

MY_PV="${PV/_/-}"
MY_P="util-linux-${MY_PV}"
LOOPAES_P="loop-AES-v3.8e"

DESCRIPTION="Loop-AES losetup utility"
HOMEPAGE="https://www.kernel.org/pub/linux/utils/util-linux/ https://github.com/util-linux/util-linux"
SRC_URI="
	https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.xz
	https://loop-aes.sourceforge.net/loop-AES/${LOOPAES_P}.tar.bz2
	verify-sig? (
		https://www.kernel.org/pub/linux/utils/util-linux/v${PV:0:4}/${MY_P}.tar.sign
		https://loop-aes.sourceforge.net/loop-AES/${LOOPAES_P}.tar.bz2.sign
	)
"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2 GPL-3 LGPL-2.1 BSD-4 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE="nls selinux static"

RDEPEND="
	selinux? ( >=sys-libs/libselinux-2.2.2-r4 )
	verify-sig? (
		>=sec-keys/openpgp-keys-karelzak-20230517
		>=sec-keys/openpgp-keys-jariruusu-20240521
	)
"
BDEPEND="
	virtual/pkgconfig
	nls? (
		app-text/po4a
		sys-devel/gettext
	)
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${WORKDIR}/${LOOPAES_P}/util-linux-${PV}.diff"
)

src_unpack() {
	if use verify-sig ; then
		verify-sig_uncompress_verify_unpack "${DISTDIR}"/${MY_P}.tar.xz \
			"${DISTDIR}"/${MY_P}.tar.sign "${UTIL_LINUX_VERIFY_SIG_OPENPGP_KEY_PATH}"

		verify-sig_verify_detached "${DISTDIR}"/${LOOPAES_P}.tar.bz2{,.sign}
		unpack ${LOOPAES_P}.tar.bz2
	else
		default
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-lfs-flags

	ECONF_SOURCE=${S} \
	econf \
		--disable-all-programs \
		--disable-libmount-mountfd-support \
		--disable-liblastlog2 \
		--disable-pam-lastlog2 \
		--disable-pylibmount \
		--disable-uuidd \
		--enable-libblkid \
		--enable-libmount \
		--enable-libsmartcols \
		--enable-losetup \
		--enable-mount \
		--without-btrfs \
		--without-libz \
		--without-libmagic \
		--without-ncurses \
		--without-ncursesw \
		--without-python \
		--without-readline \
		--without-systemd \
		--without-tinfo \
		--without-udev \
		--without-util \
		$(use_enable nls) \
		$(use_with selinux) \
		$(tc-has-tls || echo --disable-tls) \
		$(use_enable static) \
		$(use static && echo --enable-static-programs=losetup,mount)
}

src_install() {
	emake install DESTDIR="${T}/root"
	newsbin "${T}/root/sbin/losetup" loop-aes-losetup
	newbin "${T}/root/bin/mount" loop-aes-mount
	newman "${T}/root/usr/share/man/man8/losetup.8" loop-aes-losetup.8
	newman "${T}/root/usr/share/man/man8/mount.8" loop-aes-mount.8
	use static && newsbin "${T}/root/bin/losetup.static" loop-aes-losetup.static
	use static && newbin "${T}/root/bin/mount.static" loop-aes-mount.static
}
