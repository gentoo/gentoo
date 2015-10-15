# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A reimplementation of the Plan 9 shell"
HOMEPAGE="http://static.tobold.org/"
SRC_URI="http://static.tobold.org/${PN}/${P}.tar.gz"

LICENSE="rc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libedit readline"

RDEPEND="readline? ( sys-libs/readline:0 )
	libedit? ( dev-libs/libedit )"
DEPEND="${RDEPEND}"

src_configure() {
	local myconf="--with-history"
	use readline && myconf="--with-edit=readline"
	use libedit && myconf="--with-edit=editline"

	econf \
		--disable-dependency-tracking \
		"${myconf}"
}

src_install() {
	into /
	newbin rc rcsh
	newman rc.1 rcsh.1
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	ebegin "Updating /etc/shells"
	( grep -v "^/bin/rcsh$" "${ROOT}"etc/shells; echo "/bin/rcsh" ) > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"etc/shells
	eend $?
}
