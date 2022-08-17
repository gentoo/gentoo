# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="${P/_p/-}"

DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="https://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/49693/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

COMMON_DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${COMMON_DEPEND}
	sys-apps/which"
DEPEND="${COMMON_DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-ncurses-underlinking.patch
	"${FILESDIR}"/${P}-GNU_SOURCE.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		-e "s:= /:= ${EPREFIX}/:g" \
		Include.make || die

	gunzip usr_share_man/man8/ccs*.8.gz || die
}

src_configure() {
	append-cflags -Wall -Wno-unused-but-set-variable
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags ncurses)"
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"

	tc-export CC
}

src_test() {
	cd kernel_test || die
	emake
	./testall.sh || die
}

pkg_postinst() {
	elog "Execute the following command to setup the initial policy configuration:"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For more information, please visit http://tomoyo.sourceforge.jp/1.8/"
	elog
	elog "This tools are for ccs-patch'ed kernels. There are also sys-apps/tomoyo-tools"
	elog "which works with TOMOYO 2.x.x versions (already merged into Linux kernel)."
	elog "If you'd like to try them, please emerge sys-apps/tomoyo-tools instead."
}

pkg_config() {
	"${EPREFIX}"/usr/$(get_libdir)/ccs/init_policy
}
