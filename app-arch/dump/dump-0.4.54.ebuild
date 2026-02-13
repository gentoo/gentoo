# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo readme.gentoo-r1

MY_P="${PN}-$(ver_rs 2 b)"

DESCRIPTION="Dump/restore ext2fs backup utilities"
HOMEPAGE="https://dump.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/dump/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="bzip2 debug ermt lzo readline selinux sqlite ssl test +uuid zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	ermt? ( ssl )
	ssl? ( zlib )
	test? (
		lzo
		sqlite? ( uuid )
	)"

RDEPEND="
	>=sys-fs/e2fsprogs-1.27:=
	sys-apps/util-linux
	bzip2? ( app-arch/bzip2:= )
	zlib? ( >=virtual/zlib-1.1.4:= )
	lzo? ( dev-libs/lzo:2= )
	sqlite? ( dev-db/sqlite:3= )
	ermt? ( dev-libs/openssl:0= )
	ssl? ( dev-libs/openssl:0= )
	readline? (
		sys-libs/readline:0=
		sys-libs/ncurses:=
	)
	test? ( dev-cpp/catch:= )"

DEPEND="${RDEPEND}
	virtual/os-headers"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		--with-dumpdatespath=/etc/dumpdates
		--with-rmtpath='$(sbindir)/rmt'
		--enable-blkid
		--disable-werror
		$(use_enable !elibc_musl rcmd) #musl doesn't provide rcmd.
		$(use_enable bzip2)
		$(use_enable debug)
		$(use_enable ermt)
		$(use_enable lzo)
		$(use_enable readline)
		$(use_enable selinux)
		$(use_enable sqlite)
		$(use_enable ssl)
		$(use_enable uuid)
		$(use_enable zlib)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	mv "${ED}"/usr/sbin/{,dump-}rmt || die
	mv "${ED}"/usr/share/man/man8/{,dump-}rmt.8 || die
	use ermt && newsbin rmt/ermt dump-ermt

	dodoc KNOWNBUGS MAINTAINERS REPORTING-BUGS
	dodoc -r examples

	# Don't install pre-compressed files
	gunzip "${ED}"/usr/share/doc/${PF}/examples/cron_dump_to_disk/backupskel.tar.gz \
		|| die

	local DOC_CONTENTS="\n\n${CATEGORY}/${PN} installs 'rmt' as 'dump-rmt'.
	This is to avoid conflicts with app-arch/tar 'rmt'."
	readme.gentoo_create_doc
}

src_test() {
	default
	edo faketape/faketape_test
}

pkg_postinst() {
	readme.gentoo_print_elog
}
