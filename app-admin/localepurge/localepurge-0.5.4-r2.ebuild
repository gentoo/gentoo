# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils prefix

DESCRIPTION="Script to recover diskspace on unneeded locale files & localized man pages"
HOMEPAGE="https://gentoo.org
https://cgit.gentoo.org/proj/localepurge.git"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-prefix.patch
	# 164544
	epatch "${FILESDIR}"/${P}-directorysum.patch
	# 445910
	epatch "${FILESDIR}"/${P}-parentdir.patch
	 # 452208
	epatch "${FILESDIR}"/${P}-evaltotal.patch
	eprefixify ${PN}
}

src_install() {
	insinto /var/cache/${PN}
	doins defaultlist
	dosym defaultlist /var/cache/${PN}/localelist
	insinto /etc
	doins locale.nopurge
	dobin ${PN}
	doman ${PN}.8
}
