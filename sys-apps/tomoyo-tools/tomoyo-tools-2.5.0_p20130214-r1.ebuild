# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/53357/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}
	!sys-apps/ccs-tools"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-warnings.patch
)

src_prepare() {
	default

	# Fix libdir
	sed -i \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		Include.make || die

	# tinfo
	sed -i \
		-e 's|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses)|g' \
		usr_sbin/Makefile || die

	tc-export CC PKG_CONFIG
}

src_install() {
	dodir /usr/"$(get_libdir)"

	emake INSTALLDIR="${D}" install

	newenvd - 50${PN} <<- _EOF_
		CONFIG_PROTECT=/usr/$(get_libdir)/tomoyo/conf
	_EOF_

	# Fix out-of-place readme and license
	rm "${ED}"/usr/$(get_libdir)/tomoyo/{COPYING.tomoyo,README.tomoyo} || die
	dodoc README.tomoyo
}

pkg_postinst() {
	elog "Execute the following command to setup the initial policy configuration:"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For more information, please visit the following."
	elog
	elog "http://tomoyo.sourceforge.jp/"
}

pkg_config() {
	/usr/$(get_libdir)/tomoyo/init_policy
}
