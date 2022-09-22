# Copyright 2006-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_P="ntfs-3g_ntfsprogs-${PV}"

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.tuxera.com/community/ntfs-3g-download/"
HOMEPAGE="https://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"
SRC_URI="http://tuxera.com/opensource/${MY_P}.tgz"

LICENSE="GPL-2"
# The subslot matches the SONAME major #.
SLOT="0/89"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="acl debug +fuse +mount-ntfs ntfsdecrypt +ntfsprogs static-libs suid xattr"

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

PATCHES=(
	"${FILESDIR}"/${PN}-2022.5.17-configure-bashism.patch
)

src_prepare() {
	default

	# Only needed for bashism patch
	eautoreconf
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
		$(use_enable fuse ntfs-3g)
		$(use_enable acl posix-acls)
		$(use_enable xattr xattr-mappings)
		$(use_enable ntfsdecrypt crypto)
		$(use_enable ntfsprogs)
		$(use_enable static-libs static)

		--with-uuid

		# disable hd library until we have the right library in the tree and
		# don't links to hwinfo one causing issues like bug #602360
		--without-hd

		# Needed for suid
		# https://bugs.gentoo.org/822024
		--with-fuse=internal
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	if use fuse; then
		# Plugins directory
		keepdir "/usr/$(get_libdir)/ntfs-3g"
		if use suid; then
			fperms u+s /usr/bin/ntfs-3g
		fi
		if use mount-ntfs; then
			dosym mount.ntfs-3g /sbin/mount.ntfs
		fi
	fi
	find "${ED}" -name '*.la' -type f -delete || die
}
