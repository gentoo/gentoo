# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3

MY_PN=buildsystem
DESCRIPTION="Build system used for netsurf and its libraries"
HOMEPAGE="https://www.netsurf-browser.org/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${MY_PN}.git"

LICENSE="MIT"
SLOT="0"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	# We don't need upstream's CI scripts.
	find "${D}" -type f -path '*/citools/*' -delete || die
	find "${D}" -type d -name 'citools' -delete || die
}
