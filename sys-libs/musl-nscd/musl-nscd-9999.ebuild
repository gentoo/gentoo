# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 systemd

DESCRIPTION="musl-nscd is an implementation of the NSCD protocol for the musl libc"
HOMEPAGE="https://github.com/pikhq/musl-nscd"
EGIT_REPO_URI="https://github.com/pikhq/musl-nscd"
EGIT_BRANCH=master

LICENSE="MIT"
SLOT="0"
IUSE="minimal"

src_install() {
	if use minimal; then
		emake DESTDIR="${D}" install-headers
	else
		emake DESTDIR="${D}" install

		newinitd "${FILESDIR}"/nscd.initd nscd
		systemd_dounit "${FILESDIR}"/nscd.service
		systemd_newtmpfilesd "${FILESDIR}"/nscd.tmpfilesd nscd.conf

		dodoc README
	fi
}
