# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/epm/epm-9999.ebuild,v 1.1 2013/02/04 19:07:53 fuzzyray Exp $

EAPI="4"

inherit eutils git-2

DESCRIPTION="rpm workalike for Gentoo Linux"
HOMEPAGE="https://github.com/fuzzyray/epm"
SRC_URI=""
EGIT_REPO_URI="git://github.com/fuzzyray/epm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s/\"EPM version .*\";/\"EPM version 9999-${EGIT_VERSION}\";/" epm \
		|| die "Failed to set version"
}

src_compile() {
	pod2man epm > epm.1 || die "pod2man failed"
}

src_install() {
	dobin epm || die
	doman epm.1
}
