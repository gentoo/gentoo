# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="A simple console menu program"
HOMEPAGE="http://joeyh.name/code/pdmenu/"
SRC_URI="mirror://debian/pool/main/p/${PN}/pdmenu_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="nls gpm examples"

DEPEND="
	sys-libs/slang
	gpm? ( sys-libs/gpm )
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${PN}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-impl-dec.patch
)

src_prepare() {
	default
	sed \
		-e 's:\(-o pdmenu\):$(LDFLAGS) \1:g' \
		-i Makefile || die
}

src_configure() {
	CC=$(tc-getCC) econf \
		$(use_with gpm) \
		$(use_enable nls)
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin "${PN}"
	dodoc doc/ANNOUNCE doc/BUGS doc/TODO
	use examples && dodoc -r examples
	mv "doc/${PN}.man" "doc/${PN}.1" || die
	mv "doc/${PN}rc.man" "doc/${PN}rc.5" || die
	doman "doc/${PN}.1" "doc/${PN}rc.5"

}

pkg_postinst() {
	ewarn "Note this part from man page: Security warning! Any exec command"
	ewarn "that uses the 'edit' flag will be a security hole. The user need"
	ewarn "only to enter text with a ';' in it, and they can run an"
	ewarn "arbitrary command after the semicolon!"
}
