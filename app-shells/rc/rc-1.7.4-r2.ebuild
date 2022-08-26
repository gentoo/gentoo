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
	into /usr
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}

pkg_postinst() {
	if ! grep -q '^/usr/bin/rc$' "${EROOT}"/etc/shells ; then
		ebegin "Updating /etc/shells"
		echo "/usr/bin/rc" >> "${EROOT}"/etc/shells
		eend $?
	fi
}
