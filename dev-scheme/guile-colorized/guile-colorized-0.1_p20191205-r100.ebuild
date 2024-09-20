# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile

DESCRIPTION="Colorized REPL for GNU Guile"
HOMEPAGE="https://gitlab.com/NalaGinrut/guile-colorized/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/NalaGinrut/${PN}.git"
else
	# Latest release (before this commit from 2019) was in 2015
	COMMIT_SHA="1625a79f0e31849ebd537e2a58793fb45678c58f"
	SRC_URI="https://gitlab.com/NalaGinrut/${PN}/-/archive/${COMMIT_SHA}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"
fi

LICENSE="GPL-3"
SLOT="0"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_install() {
	my_install() {
		local loadpath=$(${GUILE} -c '(display (string-append (car %load-path) "/ice-9"))')
		mkdir -p "${SLOTTED_D}${loadpath}" || die
		emake -C "${S}" TARGET="${SLOTTED_D}${loadpath}" install
	}
	guile_foreach_impl my_install
	guile_merge_roots
	guile_unstrip_ccache

	einstalldocs
}
