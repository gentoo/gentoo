# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils prefix

DESCRIPTION="A tool based on colorgcc to beautify cvs output"
HOMEPAGE="https://packages.gentoo.org/package/dev-vcs/colorcvs"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-vcs/cvs"

src_prepare() {
	# fix typo
	sed -i -e 's:compiler_pid:cvs_pid:' ${PN} || die "sed failed"
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify colorcvs
}

src_install() {
	insinto /etc/profile.d
	doins "${FILESDIR}/${PN}-profile.sh" || die "doins failed"

	dobin colorcvs || die "dobin failed"
	dodoc colorcvsrc-sample || die "dodoc failed"
}

pkg_postinst() {
	echo
	einfo "An alias to colorcvs was installed for the cvs command."
	einfo "In order to immediately activate it do:"
	einfo "\tsource /etc/profile"
	echo
}
