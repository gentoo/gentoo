# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRADFITZ
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Access system calls that Perl doesn't normally provide access to"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	# https://rt.cpan.org/Ticket/Display.html?id=118696
	cp "${FILESDIR}/${PN}-${DIST_VERSION}-INSTALL.SKIP" \
		"${S}/INSTALL.SKIP" || die "Can't copy INSTALL.SKIP file"
	perl-module_src_prepare
}
