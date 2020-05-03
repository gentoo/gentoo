# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A libpurple protocol plugin that adds support for the Telegram messenger"
HOMEPAGE="https://github.com/majn/telegram-purple"
SRC_URI="https://github.com/majn/telegram-purple/releases/download/v${PV}/telegram-purple_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="gcrypt libressl +nls +webp"

RDEPEND="
	net-im/pidgin
	sys-libs/zlib:=
	gcrypt? ( dev-libs/libgcrypt:0= )
	!gcrypt? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
	)
	webp? ( media-libs/libwebp:= )
"

DEPEND="${RDEPEND}"

BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

S="${WORKDIR}/telegram-purple"

DOCS=( "AUTHORS" "CHANGELOG.md" "HACKING.md" "HACKING.BUILD.md" "README.md" )

PATCHES="${FILESDIR}/${P}-change-metadata-location.patch"

src_prepare() {
	default

	# Remove '-Werror' to make it compile
	find -name 'Makefile*' -exec sed -i -e 's/-Werror //'  {} + || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable gcrypt)
		$(use_enable nls translation)
		$(use_enable webp libwebp)
	)

	econf "${myeconfargs[@]}"
}
