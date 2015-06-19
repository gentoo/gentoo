# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/clog/clog-1.1.0.ebuild,v 1.2 2014/08/10 01:37:43 patrick Exp $

EAPI=5

EGIT_REPO_URI="https://git.tasktools.org/scm/ut/${PN}.git"
[[ ${PV} == *9999* ]] && \
	inherit git-2

inherit cmake-utils bash-completion-r1

DESCRIPTION="A colorized log tail utility"
HOMEPAGE="http://tasktools.org/projects/clog.html"
[[ ${PV} == *9999* ]] || \
	SRC_URI="http://taskwarrior.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
[[ ${PV} == *9999* ]] || \
	KEYWORDS="~amd64 ~x86 ~x64-macos"

src_prepare() {
	# Use the correct directory locations
	sed -i -e "s:/usr/local/share/doc/clog/rc:${EPREFIX}/usr/share/clog/rc:" \
		doc/man/clog.1.in || die
}

src_configure() {
	mycmakeargs=(
		-DTASK_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
