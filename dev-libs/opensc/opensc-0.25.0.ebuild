# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

DESCRIPTION="Libraries and applications to access smartcards"
HOMEPAGE="https://github.com/OpenSC/OpenSC/wiki"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenSC/OpenSC.git"
else
	SRC_URI="https://github.com/OpenSC/OpenSC/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/11"
IUSE="ctapi doc openct notify pace +pcsc-lite readline secure-messaging ssl test zlib"
RESTRICT="!test? ( test )"

RDEPEND="zlib? ( sys-libs/zlib )
	readline? ( sys-libs/readline:0= )
	ssl? ( dev-libs/openssl:0= )
	openct? ( >=dev-libs/openct-0.5.0 )
	pace? ( dev-libs/openpace:= )
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )
	notify? ( dev-libs/glib:2 )"
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

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# don't want to run upstream's clang-tidy checks
	export ac_cv_path_CLANGTIDY=""

	econf \
		--with-completiondir="$(get_bashcompdir)" \
		--disable-strict \
		--enable-man \
		$(use_enable ctapi) \
		$(use_enable doc) \
		$(use_enable notify) \
		$(use_enable openct) \
		$(use_enable pace openpace) \
		$(use_enable pcsc-lite pcsc) \
		$(use_enable readline) \
		$(use_enable secure-messaging sm) \
		$(use_enable ssl openssl) \
		$(use_enable test cmocka) \
		$(use_enable zlib)
}

src_install() {
	default

	insinto /etc/pkcs11/modules/
	doins "${FILESDIR}"/opensc.module

	find "${ED}" -name '*.la' -delete || die
}
