# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="iSNS server and client for Linux"
HOMEPAGE="https://github.com/open-iscsi/open-isns"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="debug ssl static"

DEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.100-respect-AR.patch"
)

src_prepare() {
	default
	eautoreconf
	touch aclocal/ar-lib || die #775389
}

src_configure() {
	use debug && append-cppflags -DDEBUG_TCP -DDEBUG_SCSI
	append-lfs-flags
	local myeconfargs=(
		--without-slp
		$(use_with ssl security)
		$(use_enable !static shared)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	emake DESTDIR="${D}" install_hdrs
	emake DESTDIR="${D}" install_lib
	keepdir /var/lib/${PN/open-}
	if ! use static ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}
