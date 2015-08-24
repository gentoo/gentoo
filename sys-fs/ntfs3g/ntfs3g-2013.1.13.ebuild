# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info udev toolchain-funcs

MY_PN=${PN/3g/-3g}
MY_P=${MY_PN}_ntfsprogs-${PV}

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="acl debug +external-fuse ntfsdecrypt +ntfsprogs static-libs suid xattr"

RDEPEND="!<sys-apps/util-linux-2.20.1-r2
	!sys-fs/ntfsprogs
	ntfsdecrypt? (
		>=dev-libs/libgcrypt-1.2.2:0
		<dev-libs/libgcrypt-1.6.0:0
		>=net-libs/gnutls-1.4.4
		)
	external-fuse? ( >=sys-fs/fuse-2.8.0 )"
DEPEND="${RDEPEND}
	sys-apps/attr
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog CREDITS README"

pkg_setup() {
	if use external-fuse && use kernel_linux; then
		if kernel_is lt 2 6 9; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		FUSE_FS_WARNING="You need to have FUSE module built to use ntfs-3g"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	# add missing $(sbindir) references
	sed -e 's:sbin\($\|/\):$(sbindir)\1:g' \
		-i ntfsprogs/Makefile.in src/Makefile.in || die
}

src_configure() {
	econf \
		--prefix="${EPREFIX}"/usr \
		--exec-prefix="${EPREFIX}"/usr \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable debug) \
		--enable-ldscript \
		--disable-ldconfig \
		$(use_enable acl posix-acls) \
		$(use_enable xattr xattr-mappings) \
		$(use_enable ntfsdecrypt crypto) \
		$(use_enable ntfsprogs) \
		--without-uuid \
		--enable-extras \
		$(use_enable static-libs static) \
		--with-fuse=$(usex external-fuse external internal)
}

src_install() {
	default

	use suid && fperms u+s /usr/bin/${MY_PN}
	udev_dorules "${FILESDIR}"/99-ntfs3g.rules
	prune_libtool_files

	# https://bugs.gentoo.org/398069
	rmdir "${D}"/sbin

	dosym mount.ntfs-3g /usr/sbin/mount.ntfs #374197
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# Bug 450024
		if tc-ld-is-gold; then
			eerror "ntfs-3g does not function correctly when built with the gold linker."
			eerror "Please select the bfd linker with binutils-config."
			die "GNU gold detected"
		fi
	fi
}
