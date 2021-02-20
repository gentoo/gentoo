# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Applications to monitor on a beowulf- or GRID-style clusters"
HOMEPAGE="http://www.phy.duke.edu/~rgb/Beowulf/wulfware.php"
SRC_URI="http://www.phy.duke.edu/~rgb/Beowulf/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libxml2:=
	sys-libs/ncurses:0=
	sys-libs/zlib:="
DEPEND="
	${RDEPEND}
	!sys-cluster/wulfstat
	!sys-cluster/xmlsysd"

PATCHES=(
	"${FILESDIR}"/${P}-opts_and_strip.patch
	"${FILESDIR}"/${P}-tinfo.patch #528588
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC
	append-cflags -fcommon
	econf
}

src_compile() {
	emake -j1
}

src_install() {
	emake prefix="${ED}"/usr libdir="${ED}"/usr/$(get_libdir) \
		includedir="${ED}"/usr/include sysconfdir="${ED}"/etc \
		install

	dodoc AUTHORS ChangeLog NEWS NOTES README xmlsysd/DESIGN

	# FIXME: Update to Gentoo style init script.
	rm -r "${ED}"/etc/init.d/wulf2html || die

	dosym libwulf.so.2.6.0 /usr/lib64/libwulf.so.2
	gunzip "${ED}"/usr/share/man/man?/*.gz || die
}

pkg_postinst() {
	elog "Add following line to /etc/services if you haven't done so already:"
	elog
	elog "xmlsysd       7887/tcp    # xmlsysd remote system stats"
	elog
	elog "Be sure to edit /etc/xinetd.d/xmylsysd to suit your own options."
}
