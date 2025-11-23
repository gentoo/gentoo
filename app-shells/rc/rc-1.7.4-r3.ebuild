# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

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

PATCHES=(
	"${FILESDIR}"/"${P}"-libedit.patch
	"${FILESDIR}"/"${P}"-C23.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf="--with-history"
	use readline && myconf="--with-edit=readline"
	use libedit && myconf="--with-edit=edit"

	econf "${myconf}"
}

src_install() {
	into /usr
	newbin "${PN}" "${PN}sh"
	newman "${PN}.1" "${PN}sh.1"
	einstalldocs
}

pkg_postinst() {
	if ! grep -q '^/usr/bin/rcsh$' "${EROOT}"/etc/shells ; then
		ebegin "Updating /etc/shells"
		echo "/usr/bin/rcsh" >> "${EROOT}"/etc/shells
		eend $?
	fi
}
