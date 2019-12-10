# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 b)"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Dump/restore ext2fs backup utilities"
HOMEPAGE="http://dump.sourceforge.net/"
SRC_URI="mirror://sourceforge/dump/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
# We keep uuid USE flag default dsiabled for this version. Don't forget
# to default enable it for later versions as this is the upstream default.
IUSE="bzip2 debug ermt libressl lzo readline selinux sqlite ssl static test uuid zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	ermt? ( ssl )
	ssl? ( zlib )
	test? ( sqlite? ( uuid ) )
"

RDEPEND=">=sys-fs/e2fsprogs-1.27:=
	>=sys-libs/e2fsprogs-libs-1.27:=
	sys-apps/util-linux
	bzip2? ( >=app-arch/bzip2-1.0.2:= )
	zlib? ( >=sys-libs/zlib-1.1.4:= )
	lzo? ( dev-libs/lzo:2= )
	sqlite? ( dev-db/sqlite:3= )
	ermt? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	readline? (
		sys-libs/readline:0=
		sys-libs/ncurses:=
		static? ( sys-libs/ncurses:=[static-libs] )
	)"
DEPEND="${RDEPEND}
	virtual/os-headers"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-openssl11.patch
)

src_configure() {
	local myeconfargs=(
		--with-dumpdatespath=/etc/dumpdates
		--with-rmtpath='$(sbindir)/rmt'
		--enable-blkid
		$(use_enable bzip2)
		$(use_enable debug)
		$(use_enable ermt)
		$(use_enable lzo)
		$(use_enable readline)
		$(use_enable selinux)
		$(use_enable sqlite)
		$(use_enable ssl)
		$(use_enable static static-progs)
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
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		ewarn "app-arch/dump installs 'rmt' as 'dump-rmt'."
		ewarn "This is to avoid conflicts with app-arch/tar 'rmt'."
	fi
}
