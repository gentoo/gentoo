# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PHP eselect module"
HOMEPAGE="https://https://github.com/jkroonza/eselect-composer"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jkroonza/eselect-composer.git"
else
	SRC_URI="https://github.com/jkroonza/eselect-composer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="app-admin/eselect
	!dev-php/composer:0"

DOCS=(LICENSE)
