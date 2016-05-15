# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

DESCRIPTION="Perl/Curses front-end for Taskwarrior (app-misc/task)"
HOMEPAGE="http://tasktools.org/projects/vit.html"

EGIT_REPO_URI="https://git.tasktools.org/scm/ex/vit.git"
if [[ ${PV} = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT=v${PV}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-misc/task
	dev-lang/perl
	dev-perl/Curses"
RDEPEND="${DEPEND}"

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
