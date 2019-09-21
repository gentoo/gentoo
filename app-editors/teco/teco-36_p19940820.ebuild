# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic readme.gentoo-r1

DESCRIPTION="Classic TECO editor, Predecessor to EMACS"
HOMEPAGE="http://www.ibiblio.org/pub/linux/apps/editors/tty/ http://www.ibiblio.org/pub/academic/computer-science/history/pdp-11/teco"
SRC_URI="http://www.ibiblio.org/pub/linux/apps/editors/tty/teco.tar.gz -> ${P}.tar.gz
	doc? ( https://dev.gentoo.org/~ulm/distfiles/tecodoc.tar.gz )"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-double-free.patch
	"${FILESDIR}"/${PN}-gcc4.patch
	"${FILESDIR}"/${PN}-warnings.patch
)

src_prepare() {
	default
	local pkg_config=$("$(tc-getPKG_CONFIG)" --libs ncurses)
	sed -i -e "s:\$(CC):& \$(LDFLAGS):;s:-ltermcap:${pkg_config}:" \
		Makefile || die
}

src_compile() {
	append-flags -ansi
	append-cppflags -D_POSIX_SOURCE
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin te
	doman te.1
	dodoc sample.tecorc sample.tecorc2 READ.ME
	use doc && dodoc doc/*

	DOC_CONTENTS="The TECO binary is called te.
		\nSample configurations	and documentation are available
		in /usr/share/doc/${PF}/."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
