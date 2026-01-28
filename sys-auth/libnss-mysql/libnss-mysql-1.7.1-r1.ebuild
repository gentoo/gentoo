# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="NSS MySQL Library"
HOMEPAGE="https://github.com/saknopper/libnss-mysql"
SRC_URI="https://github.com/saknopper/libnss-mysql/releases/download/v${PV}/libnss-mysql-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug"

DEPEND="dev-db/mysql-connector-c:="
RDEPEND="${DEPEND}"

DOCS=( AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS
	UPGRADING ChangeLog
)

PATCHES=(
	"${FILESDIR}/libnss-mysql-1.7.1-r1-remove_libnsl_check.patch"
)

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	newdoc sample/README README.sample

	local subdir
	for subdir in sample/{linux,freebsd,complex,minimal} ; do
		docinto "${subdir}"
		dodoc "${subdir}/"{*.sql,*.cfg}
	done
}
