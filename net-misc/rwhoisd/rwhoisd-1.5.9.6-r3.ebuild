# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="ARIN rwhois daemon"
HOMEPAGE="https://projects.arin.net/rwhois/"
SRC_URI="https://github.com/arineng/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/rwhoisd-1.5.9.6-fix-build-for-clang16.patch.xz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/libcrypt:="
RDEPEND="
	${DEPEND}
	acct-group/rwhoisd
	acct-user/rwhoisd
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

# upstream PR: https://github.com/arineng/rwhoisd/pull/2
PATCHES=(
	"${WORKDIR}/${P}-fix-build-for-clang16.patch"
	"${FILESDIR}/${P}-fix-direct-ar-call.patch"
	"${FILESDIR}/${P}-c99.patch"
)

src_prepare() {
	default
	eautoreconf #893906
}

src_compile() {
	append-cflags -DNEW_STYLE_BIN_SORT -std=gnu89

	emake -C common
	emake -C regexp
	emake -C mkdb

	default
}

src_install() {
	default

	doinitd "${FILESDIR}"/rwhoisd
	newconfd "${FILESDIR}"/rwhoisd.conf rwhoisd
}

pkg_postinst() {
	einfo "Please make sure to set the userid in rwhoisd.conf to rwhoisd."
	einfo "It is highly inadvisable to run rwhoisd as root."
}
