# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An easy to use text editor. A subset of aee"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.src.tgz"
S="${WORKDIR}/easyedit-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	!app-editors/ersatz-emacs
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-init-location.patch
	"${FILESDIR}"/${PN}-signal.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
	"${FILESDIR}"/${PN}-gcc-10.patch
	"${FILESDIR}"/${PN}-linux-termios.patch
)
DOCS=( Changes README.${PN} ${PN}.i18n.guide ${PN}.msg )

src_prepare() {
	sed -i \
		-e "s/make -/\$(MAKE) -/g" \
		-e "/^buildee/s/$/ localmake/" \
		Makefile

	sed -i \
		-e "s/\tcc /\t\\\\\$(CC) /" \
		-e "/CFLAGS =/s/\" >/ \\\\\$(LDFLAGS)\" >/" \
		-e "/other_cflag/s/ *-s//" \
		-e "s/-lcurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" \
		create.make

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
	keepdir /usr/share/${PN}
}
