# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal systemd toolchain-funcs udev usr-ldscript

DESCRIPTION="Standard EXT2/EXT3/EXT4 filesystem utilities"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${PV}/${P}.tar.xz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cron fuse nls static-libs test +tools"
RESTRICT="!test? ( test )"

RDEPEND="
	!sys-libs/${PN}-libs
	cron? ( sys-fs/lvm2[lvm] )
	fuse? ( sys-fs/fuse:0 )
	nls? ( virtual/libintl )
	tools? ( sys-apps/util-linux )
"
# For testing lib/ext2fs, lib/support/libsupport.a is required, which
# unconditionally includes '<blkid/blkid.h>' from sys-apps/util-linux.
DEPEND="
	${RDEPEND}
	test? ( sys-apps/util-linux[${MULTILIB_USEDEP}] )
"
BDEPEND="
	sys-apps/texinfo
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.42.13-fix-build-cflags.patch # bug #516854

	# Upstream patches (can usually removed with next version bump)
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ext2fs/ext2_types.h
)

src_prepare() {
	default

	cp doc/RelNotes/v${PV}.txt ChangeLog || die "Failed to copy Release Notes"

	# Get rid of doc -- we don't use them. This also prevents a sandbox
	# violation due to mktexfmt invocation
	rm -r doc || die "Failed to remove doc dir"

	# Prevent included intl cruft from building, bug #81096
	sed -i -r \
		-e 's:@LIBINTL@:@LTLIBINTL@:' \
		MCONFIG.in || die 'intl cruft'
}

multilib_src_configure() {
	# Keep the package from doing silly things, bug #261411
	export VARTEXFONTS="${T}/fonts"

	# Needs open64() prototypes and friends
	append-cppflags -D_GNU_SOURCE

	local myeconfargs=(
		--with-root-prefix="${EPREFIX}"
		$(use_with cron crond-dir "${EPREFIX}/etc/cron.d")
		--with-systemd-unit-dir="$(systemd_get_systemunitdir)"
		--with-udev-rules-dir="${EPREFIX}$(get_udevdir)/rules.d"
		--enable-symlink-install
		--enable-elf-shlibs
		$(tc-has-tls || echo --disable-tls)
		$(multilib_native_use_enable fuse fuse2fs)
		$(use_enable nls)
		$(multilib_native_use_enable tools e2initrd-helper)
		--disable-fsck
		--disable-uuidd
		--disable-lto
		--disable-largefile # need to check effect on ABI
		--with-pthread
	)

	# We use blkid/uuid from util-linux now
	if use kernel_linux ; then
		export ac_cv_lib_{uuid_uuid_generate,blkid_blkid_get_cache}=yes
		myeconfargs+=( --disable-lib{blkid,uuid} )
	fi

	ac_cv_path_LDCONFIG=: \
		ECONF_SOURCE="${S}" \
		CC="$(tc-getCC)" \
		BUILD_CC="$(tc-getBUILD_CC)" \
		BUILD_LD="$(tc-getBUILD_LD)" \
		econf "${myeconfargs[@]}"

	if grep -qs 'USE_INCLUDED_LIBINTL.*yes' config.{log,status} ; then
		eerror "INTL sanity check failed, aborting build."
		eerror "Please post your ${S}/config.log file as an"
		eerror "attachment to https://bugs.gentoo.org/81096"
		die "Preventing included intl cruft from building"
	fi
}

multilib_src_compile() {
	if multilib_is_native_abi && use tools ; then
		emake V=1
	else
		emake -C lib/et V=1
		emake -C lib/ss V=1
		emake -C lib/ext2fs V=1
		emake -C lib/e2p V=1
	fi
}

multilib_src_test() {
	if multilib_is_native_abi && use tools ; then
		emake V=1 check
	else
		# Required by lib/ext2fs's check target
		emake -C lib/support V=1

		# For non-native, there's no binaries to test. Just libraries.
		emake -C lib/et V=1 check
		emake -C lib/ss V=1 check
		emake -C lib/ext2fs V=1 check
		emake -C lib/e2p V=1 check
	fi
}

multilib_src_install() {
	if multilib_is_native_abi && use tools ; then
		emake STRIP=':' V=1 DESTDIR="${D}" install
	else
		emake -C lib/et V=1 DESTDIR="${D}" install
		emake -C lib/ss V=1 DESTDIR="${D}" install
		emake -C lib/ext2fs V=1 DESTDIR="${D}" install
		emake -C lib/e2p V=1 DESTDIR="${D}" install
	fi

	# Move shared libraries to /lib/, install static libraries to
	# /usr/lib/, and install linker scripts to /usr/lib/.
	gen_usr_ldscript -a com_err ss ext2fs e2p

	# configure doesn't have an option to disable static libs
	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi
}

multilib_src_install_all() {
	einstalldocs

	if use tools ; then
		insinto /etc
		doins "${FILESDIR}"/e2fsck.conf
	fi
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
