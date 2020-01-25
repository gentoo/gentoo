# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal usr-ldscript

MY_PN=${PN%-libs}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="e2fsprogs libraries (common error and subsystem)"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="mirror://sourceforge/e2fsprogs/${MY_P}.tar.xz
	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~m68k-mint ~x86-solaris"
IUSE="static-libs"

RDEPEND="!sys-libs/com_err
	!sys-libs/ss
	!<sys-fs/e2fsprogs-1.41.8"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.42.13-fix-build-cflags.patch #516854
)

src_prepare() {
	default

	cp doc/RelNotes/v${PV}.txt ChangeLog || die "Failed to copy Release Notes"
}

multilib_src_configure() {
	local myconf=(
		--enable-elf-shlibs
		$(tc-has-tls || echo --disable-tls)
		--disable-e2initrd-helper
		--disable-fsck
	)

	# we use blkid/uuid from util-linux now
	if use kernel_linux ; then
		export ac_cv_lib_{uuid_uuid_generate,blkid_blkid_get_cache}=yes
		myconf+=( --disable-lib{blkid,uuid} )
	fi

	ac_cv_path_LDCONFIG=: \
	ECONF_SOURCE="${S}" \
	CC="$(tc-getCC)" \
	BUILD_CC="$(tc-getBUILD_CC)" \
	BUILD_LD="$(tc-getBUILD_LD)" \
	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake -C lib/et V=1

	emake -C lib/ss V=1
}

multilib_src_test() {
	if multilib_is_native_abi; then
		emake -C lib/et V=1 check

		emake -C lib/ss V=1 check
	fi
}

multilib_src_install() {
	emake -C lib/et V=1 DESTDIR="${D}" install

	emake -C lib/ss V=1 DESTDIR="${D}" install

	# We call "gen_usr_ldscript -a" to ensure libs are present in /lib to support
	# split /usr (e.g. "e2fsck" from sys-fs/e2fsprogs is installed in /sbin and
	# links to libcom_err.so).
	gen_usr_ldscript -a com_err ss $(usex kernel_linux '' 'uuid blkid')

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi
}

multilib_src_install_all() {
	# Package installs same header twice -- use symlink instead
	dosym et/com_err.h /usr/include/com_err.h

	einstalldocs
}
