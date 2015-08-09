# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit elisp-common eutils multilib

DESCRIPTION="DMTCP is the Distributed MultiThreaded Checkpointing tool"
HOMEPAGE="http://dmtcp.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/dmtcp/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug emacs fast mpi trace"

RDEPEND="sys-libs/readline
	app-arch/gzip
	sys-kernel/linux-headers
	emacs? ( dev-lisp/clisp )
	mpi? ( virtual/mpi )
	|| ( app-shells/dash
		app-shells/zsh
		app-shells/tcsh
	)"

DEPEND="${RDEPEND}
	sys-devel/patch"

src_configure() {
	local myconf="--disable-stale-socket-handling"

	if use debug; then
		use trace && myconf=" ${myconf} --enable-ptrace-support"
		myconf=" ${myconf} --disable-pid-virtualization"
	fi

	use fast && myconf=" ${myconf} --disable-pid-virtualization \
		--enable-forked-checkpointing \
		--enable-allocator"

	use mpi && myconf=" ${myconf} --with-mpich=/usr/bin"

	econf $(use_enable debug) $myconf
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc TODO QUICK-START ${PN}/README

	dodir /usr/share/${PF}/examples
	mv "${D}"usr/$(get_libdir)/${PN}/examples "${D}"usr/share/${PF}/examples
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
