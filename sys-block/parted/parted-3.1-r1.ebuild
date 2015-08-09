# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit autotools eutils

DESCRIPTION="Create, destroy, resize, check, copy partitions and file systems"
HOMEPAGE="http://www.gnu.org/software/parted"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE="+debug device-mapper nls readline selinux static-libs test"

# specific version for gettext needed
# to fix bug 85999
RDEPEND="
	>=sys-fs/e2fsprogs-1.27
	>=sys-libs/ncurses-5.7-r7
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	readline? ( >=sys-libs/readline-5.2 )
	selinux? ( sys-libs/libselinux )
"
DEPEND="
	${RDEPEND}
	nls? ( >=sys-devel/gettext-0.12.1-r2 )
	virtual/pkgconfig
	test? (
		>=dev-libs/check-0.9.3
		dev-perl/Digest-CRC
	)
"

src_prepare() {
	# Remove tests known to FAIL instead of SKIP without OS/userland support
	sed -i libparted/tests/Makefile.am \
		-e 's|t3000-symlink.sh||g' || die "sed failed"
	sed -i tests/Makefile.am \
		-e '/t4100-msdos-partition-limits.sh/d' \
		-e '/t4100-dvh-partition-limits.sh/d' \
		-e '/t6000-dm.sh/d' || die "sed failed"
	# there is no configure flag for controlling the dev-libs/check test
	sed -i configure.ac \
		-e "s:have_check=[a-z]*:have_check=$(usex test):g" || die

	epatch "${FILESDIR}"/${PN}-3.1-zfs.patch
	epatch "${FILESDIR}"/${PN}-3.1-readline.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable device-mapper) \
		$(use_enable nls) \
		$(use_enable selinux) \
		$(use_enable static-libs static) \
		$(use_with readline) \
		--disable-rpath \
		--disable-silent-rules
}

src_test() {
	if use debug; then
		# Do not die when tests fail - some requirements are not
		# properly checked and should not lead to the ebuild failing.
		emake check
	else
		ewarn "Skipping tests because USE=-debug is set."
	fi
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO
	dodoc doc/{API,FAT,USER.jp}
	find "${ED}" -name '*.la' -exec rm -f {} +
}
