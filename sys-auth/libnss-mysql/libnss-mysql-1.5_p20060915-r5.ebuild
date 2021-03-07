# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

KEYWORDS="amd64 ppc ~sparc x86"

DESCRIPTION="NSS MySQL Library"
HOMEPAGE="http://libnss-mysql.sourceforge.net/"
SRC_URI="http://libnss-mysql.sourceforge.net/snapshot/${PN}-${PV/1.5_p/}.tgz"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="dev-db/mysql-connector-c:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS
	TODO UPGRADING ChangeLog
)

PATCHES=(
	"${FILESDIR}"/${P}-no-automagic-debug.diff
	"${FILESDIR}"/${PN}-1.5_p20060915-multiarch.patch
	"${FILESDIR}"/${PN}-1.5_p20060915-mariadb10.2.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	# Usually, authentication libraries don't belong into usr.
	# But here, it's required that the lib is in the same dir
	# as libmysql, because else failures may occur on boot if
	# udev tries to access a user / group that doesn't exist
	# on the system before /usr is mounted.
	econf --libdir="/usr/$(get_libdir)" \
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
