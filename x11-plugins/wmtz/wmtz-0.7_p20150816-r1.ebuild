# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Dockapp that shows the time in multiple timezones"
HOMEPAGE="https://www.dockapps.net/wmtz"
# https://www.dockapps.net/download/${P}.tar.gz
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	#Honour Gentoo LDFLAGS, see bug #337890.
	sed -e "s/\$(FLAGS) -o wmtz/\$(LDFLAGS) -o wmtz/" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" FLAGS="${CFLAGS}" \
		LIBDIR="-L/usr/$(get_libdir)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	insinto /etc
	doins wmtzrc
	dodoc ../{BUGS,CHANGES,README}
}
