# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We want to avoid tmpfiles.eclass because we provide it
TMPFILES_OPTIONAL=1

inherit meson

DESCRIPTION="Portable drop-in reimplementation of systemd-tmpfiles"
HOMEPAGE="https://git.pinkro.se/Rose/gardenhouse/seedfiles.git/about/"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://clone.git.pinkro.se/Rose/gardenhouse/seedfiles.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://git.pinkro.se/Rose/gardenhouse/seedfiles.git/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="virtual/acl
	!sys-apps/systemd
	!sys-apps/systemd-utils[tmpfiles]"
DEPEND="${RDEPEND}"

src_install() {
	meson_src_install
	doinitd "${FILESDIR}"/seedfiles-setup
	doinitd "${FILESDIR}"/seedfiles-setup-dev

	# We want to avoid tmpfiles.eclass because we provide it
	insinto /usr/lib/tmpfiles.d
	doins "${FILESDIR}"/{tmp,legacy}.conf
}
