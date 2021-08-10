# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A libpurple protocol plugin that adds support for the Telegram messenger"
HOMEPAGE="https://github.com/majn/telegram-purple"
SRC_URI="https://github.com/majn/telegram-purple/releases/download/v${PV}/telegram-purple_${PV}.orig.tar.gz"
S="${WORKDIR}/telegram-purple"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="gcrypt +nls +png +webp"

RDEPEND="
	net-im/pidgin
	sys-libs/zlib:=
	gcrypt? ( dev-libs/libgcrypt:0= )
	!gcrypt? ( dev-libs/openssl:0= )
	png? ( media-libs/libpng:0= )
	webp? ( media-libs/libwebp:= )
"

DEPEND="${RDEPEND}"

BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

DOCS=( "AUTHORS" "CHANGELOG.md" "HACKING.md" "HACKING.BUILD.md" "README.md" )

src_prepare() {
	default

	# Remove '-Werror' to make it compile
	find -name 'Makefile*' -exec sed -i -e 's/-Werror //' {} + || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable gcrypt)
		$(use_enable nls translation)
		$(use_enable png libpng)
		$(use_enable webp libwebp)
	)

	econf "${myeconfargs[@]}"
}
