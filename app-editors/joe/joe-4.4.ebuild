# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
HOMEPAGE="https://sourceforge.net/projects/joe-editor/"
SRC_URI="mirror://sourceforge/joe-editor/${P}.tar.gz"

LICENSE="GPL-1+ CC-BY-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="xterm"

DEPEND=">=sys-libs/ncurses-5.2-r2:0="
RDEPEND="${DEPEND}
	xterm? ( >=x11-terms/xterm-239 )"

DOCS=( README.md NEWS.md docs/hacking.md docs/man.md )

PATCHES=( "${FILESDIR}/${PN}-4.3-tinfo.patch" )

src_prepare() {
	default
	# Enable xterm mouse support in the rc files
	if use xterm; then
		pushd "${S}"/rc &>/dev/null || die
		local i
		for i in *rc*.in; do
			sed -e 's/^ -\(mouse\|joexterm\)/-\1/' -i "${i}" || die
		done
		popd &>/dev/null
	fi
	eautoreconf
}

pkg_postinst() {
	if use xterm; then
		elog "To enable full xterm clipboard you need to set the allowWindowOps"
		elog "resources to true. This is usually found in /etc/X11/app-defaults/XTerm"
		elog "This is false by default due to potential security problems on some"
		elog "architectures (see bug #91453)."
	fi
}
