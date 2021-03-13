# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~amd64-linux"
IUSE="curl dar32 dar64 doc gcrypt gpg lzo nls static static-libs xattr"

RESTRICT="test" # need to be run as root

RDEPEND="
	>=sys-libs/zlib-1.2.3:=
	!static? (
		app-arch/bzip2:=
		app-arch/xz-utils:=
		sys-libs/libcap
		curl? ( net-misc/curl )
		gcrypt? ( dev-libs/libgcrypt:0= )
		gpg? ( app-crypt/gpgme )
		lzo? ( dev-libs/lzo:= )
		xattr? ( sys-apps/attr:= )
	)"

DEPEND="
	${RDEPEND}
	static? (
		app-arch/bzip2[static-libs]
		app-arch/xz-utils[static-libs]
		sys-libs/libcap[static-libs]
		sys-libs/zlib[static-libs]
		curl? ( net-misc/curl[static-libs] )
		lzo? ( dev-libs/lzo[static-libs] )
		xattr? ( sys-apps/attr[static-libs] )
	)
"
BDEPEND="
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
	doc? ( app-doc/doxygen )
"

REQUIRED_USE="?? ( dar32 dar64 )
		gpg? ( gcrypt )"

src_configure() {
	# configure.ac is totally funked up regarding the AC_ARG_ENABLE
	# logic.
	# For example "--enable-dar-static" causes configure to DISABLE
	# static builds of dar.
	# Do _not_ use $(use_enable) until you have verified that the
	# logic has been fixed by upstream.
	local myconf=(
		--disable-python-binding
		--disable-upx
		$(usex curl '' --disable-libcurl-linking)
		$(usex dar32 --enable-mode=32 '')
		$(usex dar64 --enable-mode=64 '')
		$(usex doc '' --disable-build-html)
		#$(usex examples --enable-examples '')
		$(usex gcrypt '' --disable-libgcrypt-linking)
		$(usex gpg '' --disable-gpgme-linking)
		$(usex lzo '' --disable-liblzo2-linking)
		$(usex nls '' --disable-nls)
		#$(usex rsync '' --disable-librsync-linking)
		$(usex xattr '' --disable-ea-support)
	)

	# Bug 103741
	filter-flags -fomit-frame-pointer

	if ! use static ; then
		myconf+=( --disable-dar-static )
		if ! use static-libs ; then
			myconf+=( --disable-static )
		fi
	fi

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	local DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
	einstalldocs

	find "${ED}" -name '*.la' -delete || die

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi
}
