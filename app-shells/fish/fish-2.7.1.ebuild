# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="http://fishshell.com/"
SRC_URI="https://github.com/${PN}-shell/${PN}-shell/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" = *_* ]] || \
KEYWORDS="amd64 ~arm arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="nls test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libpcre2-10.21[pcre32]
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	sys-devel/bc
	nls? ( sys-devel/gettext )
	test? ( dev-tcltk/expect )
"

PATCHES=( "${FILESDIR}/${P}-fix-printf-o-handling-on-ppc.patch"
	"${FILESDIR}/fix-histfile-test-on-ppc.patch" )

S="${WORKDIR}/${MY_P}"

src_configure() {
	# Set things up for fish to be a default shell.
	# It has to be in /bin in case /usr is unavailable.
	# Also, all of its utilities have to be in /bin.
	econf \
		--bindir="${EPREFIX}"/bin \
		--without-included-pcre2 \
		$(use_with nls gettext)
}

src_compile() {
	emake V=1
}

src_install() {
	emake DESTDIR="${D}" V=1 install
}

src_test() {
	if has_version ~${CATEGORY}/${P} ; then
		emake -j1 V=1 SHOW_INTERACTIVE_LOG=1 test
	else
		ewarn "Some tests only work when the package is already installed"
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
