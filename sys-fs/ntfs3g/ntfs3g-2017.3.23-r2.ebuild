# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info udev toolchain-funcs libtool

MY_PN=${PN/3g/-3g}
MY_P=${MY_PN}_ntfsprogs-${PV}

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"

LICENSE="GPL-2"
# The subslot matches the SONAME major #.
SLOT="0/88"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="acl debug +external-fuse ntfsdecrypt +ntfsprogs static-libs suid xattr"

RDEPEND="!<sys-apps/util-linux-2.20.1-r2
	!sys-fs/ntfsprogs
	ntfsdecrypt? (
		>=dev-libs/libgcrypt-1.2.2:0
		>=net-libs/gnutls-1.4.4
	)
	external-fuse? (
		>=sys-fs/fuse-2.8.0:0
	)
"
DEPEND="${RDEPEND}
	sys-apps/attr
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS ChangeLog CREDITS README"

PATCHES=(
	"${FILESDIR}"/${PN}-2014.2.15-no-split-usr.patch
	"${FILESDIR}"/${PN}-2016.2.22-sysmacros.patch #580136
	# Fedora fixes
	"${FILESDIR}"/${PN}-2017.3.23-check-mftmirr.patch
	"${FILESDIR}"/${PN}-2017.3.23-big-sectors.patch
	"${FILESDIR}"/${PN}-2017.3.23-full-clusters.patch
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
	default
	# Keep the symlinks in the same place we put the main binaries.
	# Having them in / when all the progs are in /usr is pointless.
	sed -i \
		-e 's:/sbin:$(sbindir):g' \
		{ntfsprogs,src}/Makefile.in || die #578336
	# Note: patches apply to Makefile.in, so don't run autotools here.
	elibtoolize
}

src_configure() {
	# disable hd library until we have the right library in the tree and
	# don't links to hwinfo one causing issues like bug #602360
	tc-ld-disable-gold
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
		$(use_enable ntfsprogs quarantined) \
		--without-uuid \
		--without-hd \
		--enable-extras \
		$(use_enable static-libs static) \
		--with-fuse=$(usex external-fuse external internal)
}

src_install() {
	default

	use suid && fperms u+s /usr/bin/${MY_PN}
	# Not needed with the link of mount.ntfs being created, causes
	# issues like bug #635080
#	udev_dorules "${FILESDIR}"/99-ntfs3g.rules
	dosym mount.ntfs-3g /usr/sbin/mount.ntfs #374197

	find "${D}" -name '*.la' -type f -delete || die
}
