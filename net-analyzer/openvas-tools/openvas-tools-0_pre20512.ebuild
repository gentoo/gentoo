# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="A remote security scanner for Linux (extra tools)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/tools

src_install() {
	insinto /usr/$(get_libdir)/nagios/plugins/
	doins nagios/*

	dosbin openvas-check-setup

	insinto /usr/share/vim/vimfiles/syntax
	doins nasl.vim
}
