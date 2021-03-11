# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux"
IUSE="curl dar32 dar64 doc gcrypt gpg lzo nls rsync threads xattr"

RESTRICT="test" # need to be run as root

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	sys-libs/libcap
	>=sys-libs/zlib-1.2.3:=
	curl? ( net-misc/curl )
	gcrypt? ( dev-libs/libgcrypt:0= )
	gpg? ( app-crypt/gpgme )
	lzo? ( dev-libs/lzo:= )
	rsync? ( net-libs/librsync:= )
	threads? ( dev-libs/libthreadar:= )
	xattr? ( sys-apps/attr:= )
"

DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-doc/doxygen )
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
"

REQUIRED_USE="?? ( dar32 dar64 )
		gpg? ( gcrypt )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_configure() {
	# configure.ac is totally funked up regarding the AC_ARG_ENABLE
	# logic.
	# For example "--enable-dar-static" causes configure to DISABLE
	# static builds of dar.
	# Do _not_ use $(use_enable) until you have verified that the
	# logic has been fixed by upstream.
	local myconf=(
		--disable-dar-static
		--disable-python-binding
		--disable-static
		--disable-upx
		$(usex curl '' --disable-libcurl-linking)
		$(usex dar32 --enable-mode=32 '')
		$(usex dar64 --enable-mode=64 '')
		$(usex doc '' --disable-build-html)
		$(usex gcrypt '' --disable-libgcrypt-linking)
		$(usex gpg '' --disable-gpgme-linking)
		$(usex lzo '' --disable-liblzo2-linking)
		$(usex nls '' --disable-nls)
		$(usex rsync '' --disable-librsync-linking)
		$(usex threads '' --disable-threadar)
		$(usex xattr '' --disable-ea-support)
	)

	# Bug 103741
	filter-flags -fomit-frame-pointer

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die

	# Bug 729150
	rm "${ED}/usr/share/doc/${PF}/html/samples/MyBackup.sh.tar.gz" || die
}
