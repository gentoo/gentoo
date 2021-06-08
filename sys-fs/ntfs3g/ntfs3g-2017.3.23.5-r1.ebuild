# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info toolchain-funcs

MY_P="ntfs-3g_ntfsprogs-${PV%.*}AR.${PV##*.}"

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
HOMEPAGE="https://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"
#SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"
SRC_URI="https://jp-andre.pagesperso-orange.fr/${MY_P}.tgz"

LICENSE="GPL-2"
# The subslot matches the SONAME major #.
SLOT="0/885"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="acl debug ntfsdecrypt +ntfsprogs static-libs suid xattr"

RDEPEND="
	sys-apps/util-linux:0=
	ntfsdecrypt? (
		>=dev-libs/libgcrypt-1.2.2:0
		>=net-libs/gnutls-1.4.4
	)
"
DEPEND="${RDEPEND}
	sys-apps/attr
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	CONFIG_CHECK="~FUSE_FS"
	FUSE_FS_WARNING="You need to have FUSE module built to use ntfs-3g"
	linux-info_pkg_setup
}

src_configure() {
	tc-ld-disable-gold

	local myconf=(
		# passing --exec-prefix is needed as the build system is trying to be clever
		# and install itself into / instead of /usr in order to be compatible with
		# separate-/usr setups (which we don't support without an initrd).
		--exec-prefix="${EPREFIX}"/usr

		--disable-ldconfig
		--enable-extras
		$(use_enable debug)
		$(use_enable acl posix-acls)
		$(use_enable xattr xattr-mappings)
		$(use_enable ntfsdecrypt crypto)
		$(use_enable ntfsprogs)
		$(use_enable ntfsprogs quarantined)
		$(use_enable static-libs static)

		--with-uuid

		# disable hd library until we have the right library in the tree and
		# don't links to hwinfo one causing issues like bug #602360
		--without-hd
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	use suid && fperms u+s /usr/bin/ntfs-3g
	dosym mount.ntfs-3g /sbin/mount.ntfs
	find "${D}" -name '*.la' -type f -delete || die
	# https://bugs.gentoo.org/760780
	keepdir "/usr/$(get_libdir)/ntfs-3g"
}
