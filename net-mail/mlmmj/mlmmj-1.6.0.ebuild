# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Mailing list managing made joyful"
HOMEPAGE="https://codeberg.org/mlmmj/mlmmj"
SRC_URI="https://codeberg.org/${PN}/${PN}/releases/download/RELEASE_${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="virtual/libiconv"
DEPEND="
	${COMMON_DEPEND}
	test? (
		dev-libs/atf
		dev-util/kyua
	)
"
RDEPEND="
	${COMMON_DEPEND}
	virtual/mta
"
BDEPEND="test? ( virtual/pkgconfig )"

DOCS=( AUTHORS ChangeLog FAQ TODO TUNABLES.md UPGRADE )

PATCHES=(
	"${FILESDIR}"/mlmmj-1.4.7-cflags.patch
)

src_prepare() {
	default
	eautoreconf

	# bug #259962
	sed -i contrib/web/perl-admin/htdocs/subscribers.cgi \
		-e "s:/usr/local/bin/:${EPREFIX}/usr/bin/:g" || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable test tests)
		--enable-receive-strip
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /usr/share/mlmmj
	doins -r contrib/web/*

	dodoc README.*
}

pkg_postinst() {
	elog "mlmmj comes with serveral webinterfaces:"
	elog "- One for user subscribing/unsubscribing"
	elog "- One for admin tasks"
	elog "both available in a php and perl module."
	elog "For more info have a look in ${EROOT}/usr/share/mlmmj"
}
