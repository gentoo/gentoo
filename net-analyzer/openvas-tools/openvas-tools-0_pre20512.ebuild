# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-tools/openvas-tools-0_pre20512.ebuild,v 1.1 2014/10/01 11:24:01 jlec Exp $

EAPI=5

inherit multilib

DESCRIPTION="A remote security scanner for Linux (extra tools)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

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
