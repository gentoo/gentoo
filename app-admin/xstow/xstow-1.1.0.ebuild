# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Replacement for GNU stow with extensions"
HOMEPAGE="http://xstow.sourceforge.net/"
SRC_URI="mirror://sourceforge/xstow/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ncurses"

DEPEND="ncurses? ( sys-libs/ncurses:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_with ncurses curses)
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${PF}/html" install
	dodoc AUTHORS ChangeLog NEWS README TODO

	# Create new STOWDIR
	keepdir /var/lib/xstow

	# Install env.d file to add STOWDIR to PATH and LDPATH
	doenvd "${FILESDIR}"/99xstow
}

pkg_postinst() {
	elog "We now recommend that you use /var/lib/xstow as your STOWDIR"
	elog "instead of /usr/local in order to avoid conflicts with the"
	elog "symlink from /usr/lib64 -> /usr/lib.  See Bug 246264"
	elog "(regarding app-admin/stow, equally applicable to XStow) for"
	elog "more details on this change."
	elog "For your convenience, PATH has been updated to include"
	elog "/var/lib/bin."
}
