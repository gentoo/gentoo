# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86 ~amd64-linux"
IUSE="argon2 curl dar32 dar64 doc gcrypt gpg lz4 lzo nls rsync threads xattr"

REQUIRED_USE="?? ( dar32 dar64 )
		gpg? ( gcrypt )"

RESTRICT="test" # need to be run as root

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils
	app-arch/zstd:=
	sys-libs/libcap
	>=sys-libs/zlib-1.2.3:=
	argon2? ( app-crypt/argon2:= )
	curl? ( net-misc/curl )
	gcrypt? (
		dev-libs/libgcrypt:0=
		dev-libs/libgpg-error
	)
	gpg? ( app-crypt/gpgme:= )
	lz4? ( app-arch/lz4:= )
	lzo? ( dev-libs/lzo:2 )
	nls? ( virtual/libintl )
	rsync? ( net-libs/librsync:= )
	threads? ( dev-libs/libthreadar )
	xattr? ( sys-apps/attr )
"

DEPEND="${RDEPEND}"

BDEPEND="
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
"

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
		--disable-upx
		$(usev !argon2 --disable-libargon2-linking)
		$(usev !curl --disable-libcurl-linking)
		$(usev dar32 --enable-mode=32)
		$(usev dar64 --enable-mode=64)
		$(usev !doc --disable-build-html)
		$(usev !gcrypt --disable-libgcrypt-linking)
		$(usev !gpg --disable-gpgme-linking)
		$(usev !lz4 --disable-liblz4-linking)
		$(usev !lzo --disable-liblzo2-linking)
		$(usev !nls --disable-nls)
		$(usev !rsync --disable-librsync-linking)
		$(usev !threads --disable-threadar)
		$(usev !xattr --disable-ea-support)
	)

	# Bug 103741
	filter-flags -fomit-frame-pointer

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	find "${ED}" -name "*.la" -delete || die

	# Bug 729150
	rm "${ED}/usr/share/doc/${PF}/html/samples/MyBackup.sh.tar.gz" || die
}
