# Copyright 1999-2025 Gentoo Authors
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
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="LGPL-2.1+ BSD"
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
# vim-core needed for xxd in tests
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	test? (
		app-editors/vim-core
		dev-util/cmocka
		dev-libs/softhsm
	)"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	pcsc-lite? ( !openct !ctapi )
	openct? ( !pcsc-lite !ctapi )
	ctapi? ( !pcsc-lite !openct )
	|| ( pcsc-lite openct ctapi )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.26.1-c23-tests.patch
)

src_prepare() {
	# This test is known to fail, for a long time upstream has carried
	# version-specific patches which they would update on every version bump.
	# There doesn't appear to be a permanent solution yet.
	sed -i "/test-pkcs11-tool-unwrap-wrap-test.sh/d" "tests/Makefile.am" || die
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

src_test() {
	P11LIB="${ESYSROOT}/usr/$(get_libdir)/softhsm/libsofthsm2.so" default
}

src_install() {
	default

	insinto /etc/pkcs11/modules/
	doins "${FILESDIR}"/opensc.module

	find "${ED}" -name '*.la' -delete || die
}
