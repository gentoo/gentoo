# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib autotools toolchain-funcs

DESCRIPTION="Package maintenance system for Debian"
HOMEPAGE="https://packages.qa.debian.org/dpkg"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris ~x86-solaris"
IUSE="+bzip2 libmd +lzma nls selinux static-libs test unicode +update-alternatives +zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.14.2:=
	bzip2? ( app-arch/bzip2 )
	libmd? ( app-crypt/libmd )
	lzma? ( app-arch/xz-utils )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )
	zlib? ( >=sys-libs/zlib-1.1.4 )
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	test? (
		dev-perl/IO-String
		dev-perl/Test-Pod
		virtual/perl-Test-Harness
	)
"
BDEPEND="
	sys-devel/flex
	nls? (
		app-text/po4a
		>=sys-devel/gettext-0.18.2
	)
"
DOCS=(
	ChangeLog
	THANKS
	TODO
)
PATCHES=(
	"${FILESDIR}"/${PN}-1.18.12-dpkg_buildpackage-test.patch
	"${FILESDIR}"/${PN}-1.18.12-flags.patch
	"${FILESDIR}"/${PN}-1.18.12-rsyncable.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	tc-export CC
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable unicode) \
		$(use_enable update-alternatives) \
		$(use_with bzip2 libbz2) \
		$(use_with libmd) \
		$(use_with lzma liblzma) \
		$(use_with selinux libselinux) \
		$(use_with zlib libz) \
		--disable-compiler-warnings \
		--disable-dselect \
		--disable-start-stop-daemon \
		--localstatedir="${EPREFIX}"/var
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	default

	keepdir \
		/usr/$(get_libdir)/db/methods/{mnt,floppy,disk} \
		/var/lib/dpkg/{alternatives,info,parts,updates}

	find "${ED}" -name '*.la' -delete || die
}
