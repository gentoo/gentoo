# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="fish is the Friendly Interactive SHell"
HOMEPAGE="http://fishshell.com/"
SRC_URI="http://fishshell.com/files/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="nls"

RDEPEND="
	>=dev-libs/libpcre2-10.21[pcre32]
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	sys-devel/bc
	nls? ( sys-devel/gettext )
"

PATCHES=( "${FILESDIR}/${P}-honor-linguas.patch" )

src_configure() {
	# Set things up for fish to be a default shell.
	# It has to be in /bin in case /usr is unavailable.
	# Also, all of its utilities have to be in /bin.
	econf \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--bindir="${EPREFIX}"/bin \
		--without-included-pcre2 \
		$(use_with nls gettext)
}

src_test() {
	if has_version ~${CATEGORY}/${P} ; then
		emake test
	else
		ewarn "The test suite only works when the package is already installed"
	fi
}

pkg_postinst() {
	elog "fish is now installed on your system."
	elog "To run fish, type 'fish' in your terminal."
	elog
	elog "It is advised not to set fish as a default login shell."
	elog "see bug #545830 for more details."
	elog "Executing fish using ~/.bashrc is an alternative"
	elog "see https://wiki.gentoo.org/wiki/Fish#Caveats for details"
	elog
	elog "To set your colors, run 'fish_config'"
	elog "To scan your man pages for completions, run 'fish_update_completions'"
	elog "To autocomplete command suggestions press Ctrl + F or right arrow key."
	elog
	elog "Please add a \"BROWSER\" variable to ${PN}'s environment pointing to the"
	elog "browser of your choice to get acces to ${PN}'s help system:"
	elog "  BROWSER=\"/usr/bin/firefox\""
	elog
	elog "In order to get lzma and xz support for man-page completion please"
	elog "emerge one of the following packages:"
	elog "  dev-python/backports-lzma"
	elog "  >=dev-lang/python-3.3"
	elog
	elog "If you have issues with cut'n'paste in X-terminals, install the"
	elog "x11-misc/xsel package."
	elog
	elog "Have fun!"
}
