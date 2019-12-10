# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Libraries and applications to access smartcards"
HOMEPAGE="https://github.com/OpenSC/OpenSC/wiki"
SRC_URI="https://github.com/OpenSC/OpenSC/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="ctapi doc libressl openct notify +pcsc-lite readline secure-messaging ssl test zlib"
RESTRICT="!test? ( test )"

RDEPEND="zlib? ( sys-libs/zlib )
	readline? ( sys-libs/readline:0= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( >=dev-libs/libressl-2.7.0:0= )
	)
	openct? ( >=dev-libs/openct-0.5.0 )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )
	notify? ( dev-libs/glib:2= )"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	pcsc-lite? ( !openct !ctapi )
	openct? ( !pcsc-lite !ctapi )
	ctapi? ( !pcsc-lite !openct )
	|| ( pcsc-lite openct ctapi )"

PATCHES=(
	"${FILESDIR}/${P}-p11test_common.h.patch"
)

src_configure() {
	econf \
		--with-completiondir="$(get_bashcompdir)" \
		--disable-openpace \
		--disable-static \
		--disable-strict \
		--enable-man \
		$(use_enable ctapi) \
		$(use_enable doc) \
		$(use_enable notify ) \
		$(use_enable openct) \
		$(use_enable openct) \
		$(use_enable pcsc-lite pcsc) \
		$(use_enable readline) \
		$(use_enable secure-messaging sm) \
		$(use_enable ssl openssl) \
		$(use_enable test tests) \
		$(use_enable zlib)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
