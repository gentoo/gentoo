# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Perl/Curses front-end for Taskwarrior (app-misc/task)"
HOMEPAGE="http://tasktools.org/projects/vit.html"
SRC_URI="https://git.tasktools.org/plugins/servlet/archive/projects/EX/repos/vit?at=refs%2Ftags%2Fv1.2&format=tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	app-misc/task
	dev-lang/perl
	dev-perl/Curses"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-allow-nonsudo-install.patch \
		"${FILESDIR}"/${PN}-fix-man-installs.patch
}

src_install() {
	emake DESTDIR="${D}" SUDO="" install
	dodoc AUTHORS README CHANGES
	doman vit.1 vitrc.5

	rm -rf "${ED}"/usr/man
}
