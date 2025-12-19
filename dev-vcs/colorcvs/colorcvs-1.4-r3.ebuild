# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="A tool based on colorgcc to beautify cvs output"
HOMEPAGE="https://packages.gentoo.org/package/dev-vcs/colorcvs"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-lang/perl
	dev-vcs/cvs"

PATCHES=( "${FILESDIR}"/${P}-prefix.patch )

src_prepare() {
	default
	eprefixify colorcvs
}

src_install() {
	dobin colorcvs
	dodoc colorcvsrc-sample

	insinto /etc/profile.d
	doins "${FILESDIR}"/colorcvs-profile.sh
}

pkg_postinst() {
	einfo "An alias to colorcvs was installed for the cvs command."
	einfo "In order to immediately activate it do:"
	einfo "\tsource /etc/profile"
}
