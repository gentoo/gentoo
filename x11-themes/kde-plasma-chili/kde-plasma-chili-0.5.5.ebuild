# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The hottest login theme around for KDE Plasma 5"
HOMEPAGE="https://github.com/MarianArlt/kde-plasma-chili"
SRC_URI="https://github.com/MarianArlt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DOCS=(
	AUTHORS
	CHANGELOG.md
	CREDITS
	README.md
)

src_install() {
	einstalldocs
	rm "${DOCS[@]}" LICENSE.md || die

	insinto "/usr/share/sddm/themes/${PN}"
	doins -r *
}
