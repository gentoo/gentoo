# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit prefix

DESCRIPTION="Script to recover diskspace on unneeded locale files & localized man pages"
HOMEPAGE="https://gentoo.org
https://cgit.gentoo.org/proj/localepurge.git"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.4-prefix.patch
	"${FILESDIR}"/${PN}-0.5.4-directorysum.patch # 164544
	"${FILESDIR}"/${PN}-0.5.4-parentdir.patch #445910
	"${FILESDIR}"/${PN}-0.5.4-evaltotal.patch #452208
)

src_prepare() {
	default
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
