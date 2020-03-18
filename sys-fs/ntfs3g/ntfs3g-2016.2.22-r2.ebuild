# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils linux-info ltprune udev toolchain-funcs libtool

MY_PN=${PN/3g/-3g}
MY_P=${MY_PN}_ntfsprogs-${PV}

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"

LICENSE="GPL-2"
# The subslot matches the SONAME major #.
SLOT="0/87"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="acl debug +external-fuse ntfsdecrypt +ntfsprogs static-libs suid xattr"

RDEPEND="!<sys-apps/util-linux-2.20.1-r2
	!sys-fs/ntfsprogs
	ntfsdecrypt? (
		>=dev-libs/libgcrypt-1.2.2:0
		>=net-libs/gnutls-1.4.4
	)
	external-fuse? (
		>=sys-fs/fuse-2.8.0
		<sys-fs/fuse-3.0.0_pre
	)"
DEPEND="${RDEPEND}
	sys-apps/attr
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS ChangeLog CREDITS README"

PATCHES=(
	"${FILESDIR}"/${PN}-2014.2.15-no-split-usr.patch
	"${FILESDIR}"/${PN}-2016.2.22-sysmacros.patch #580136
	"${FILESDIR}"/${PN}-2016.2.22-CVE-2017-0358.patch #607912
)

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
	epatch "${PATCHES[@]}"
	# Keep the symlinks in the same place we put the main binaries.
	# Having them in / when all the progs are in /usr is pointless.
	sed -i \
		-e 's:/sbin:$(sbindir):g' \
		{ntfsprogs,src}/Makefile.in || die #578336
	# Note: patches apply to Makefile.in, so don't run autotools here.
	elibtoolize
}

src_configure() {
	tc-ld-disable-gold
	# passing --exec-prefix is needed as the build system is trying to be clever
	# and install itself into / instead of /usr in order to be compatible with
	# separate-/usr setups (which we don't support without an initrd).
	econf \
		--exec-prefix="${EPREFIX}"/usr \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable debug) \
		--enable-ldscript \
		--disable-ldconfig \
		$(use_enable acl posix-acls) \
		$(use_enable xattr xattr-mappings) \
		$(use_enable ntfsdecrypt crypto) \
		$(use_enable ntfsprogs) \
		$(use_enable ntfsprogs quarantined) \
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

	dosym mount.ntfs-3g /usr/sbin/mount.ntfs #374197
}
