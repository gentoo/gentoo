# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/aespipe/aespipe-2.4c-r1.ebuild,v 1.1 2015/03/06 15:16:41 alonbl Exp $

EAPI=5

inherit flag-o-matic

DESCRIPTION="Encrypts data from stdin to stdout"
HOMEPAGE="http://loop-aes.sourceforge.net"
SRC_URI="http://loop-aes.sourceforge.net/aespipe/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="+asm cpu_flags_x86_aes cpu_flags_x86_padlock static"
DEPEND=""
RDEPEND="app-arch/sharutils
	app-crypt/gnupg"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	use static && append-ldflags -static
	econf \
		$(use_enable asm) \
		$(use_enable cpu_flags_x86_aes intelaes) \
		$(use_enable cpu_flags_x86_padlock padlock)
}
