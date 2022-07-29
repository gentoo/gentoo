# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A reimplementation of the Plan 9 shell"
HOMEPAGE="http://static.tobold.org/"
SRC_URI="http://static.tobold.org/${PN}/${P}.tar.gz"

LICENSE="rc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libedit readline"

RDEPEND="sys-libs/ncurses:=
	readline? ( sys-libs/readline:= )
	libedit? ( dev-libs/libedit )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myconf="--with-history"
	use readline && myconf="--with-edit=readline"
	use libedit && myconf="--with-edit=edit"

	econf "${myconf}"
}

src_install() {
	into  "${EROOT}/usr"
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}

pkg_postinst() {
	local bin="/usr/bin/rc"
	elog "Updating /etc/shells"
	# If not match, add /usr/bin/rc to /etc/shells
	(grep -q "^$bin$" "${EROOT}/etc/shells" || echo $bin >> $_) || die
}
