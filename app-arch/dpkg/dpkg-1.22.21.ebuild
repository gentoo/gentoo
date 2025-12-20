# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a toolchain-funcs multiprocessing

DESCRIPTION="Package maintenance system for Debian"
HOMEPAGE="https://packages.qa.debian.org/dpkg"
SRC_URI="mirror://debian/pool/main/d/${PN}/${P/-/_}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+bzip2 +lzma nls selinux test +update-alternatives +zlib +zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-arch/gzip-1.7
	>=app-arch/tar-1.34-r1
	app-crypt/libmd
	>=dev-lang/perl-5.32.1:=
	sys-libs/ncurses:=[unicode(+)]
	bzip2? ( app-arch/bzip2 )
	elibc_musl? ( sys-libs/obstack-standalone )
	lzma? ( app-arch/xz-utils )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )
	zlib? ( >=virtual/zlib-1.1.4:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	test? (
		dev-perl/IO-String
		dev-perl/Test-Pod
	)
"
BDEPEND="
	sys-devel/flex
	nls? (
		app-text/po4a
		>=sys-devel/gettext-0.18.2
	)
"
RDEPEND+=" selinux? ( sec-policy/selinux-dpkg )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.22.0-flags.patch
)

src_prepare() {
	default

	sed -i -e 's|\<ar\>|${AR}|g' src/at/deb-format.at src/at/testsuite || die

	eautoreconf
}

src_configure() {
	tc-export AR CC
	lto-guarantee-fat

	# dpkg uses LT_INIT([disable-shared]) in configure.ac where GNU libtool
	# enables static if both --disable-shared and --disable-static are set while
	# slibtool disables both so explicitly set --enable-static until upstream
	# supports shared libraries.
	# https://bugs.gentoo.org/956332
	local myconf=(
		# We don't want to override our toolchain defaults which
		# set the same things.
		--disable-compiler-hardening
		--disable-compiler-warnings
		--disable-devel-docs
		--disable-dselect
		--disable-start-stop-daemon
		--enable-static
		--enable-unicode
		--localstatedir="${EPREFIX}"/var
		$(use_enable nls)
		$(use_enable update-alternatives)
		$(use_with bzip2 libbz2)
		$(use_with lzma liblzma)
		$(use_with selinux libselinux)
		$(use_with zlib libz)
		$(use_with zstd libzstd)
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_test() {
	emake -Onone check TEST_PARALLEL="$(makeopts_jobs)" TEST_VERBOSE=1
}

src_install() {
	local DOCS=( debian/changelog THANKS TODO )
	default
	strip-lto-bytecode usr/$(get_libdir)/libdpkg.a

	# https://bugs.gentoo.org/835520
	mv -v "${ED}"/usr/share/zsh/{vendor-completions,site-functions} || die

	# https://bugs.gentoo.org/840320
	insinto /etc/dpkg/origins
	newins - gentoo <<-_EOF_
		Vendor: Gentoo
		Vendor-URL: https://www.gentoo.org/
		Bugs: https://bugs.gentoo.org/
	_EOF_
	dosym gentoo /etc/dpkg/origins/default

	keepdir \
		/usr/$(get_libdir)/db/methods/{mnt,floppy,disk} \
		/var/lib/dpkg/{alternatives,info,parts,updates}

	find "${ED}" -name '*.la' -delete || die
}
