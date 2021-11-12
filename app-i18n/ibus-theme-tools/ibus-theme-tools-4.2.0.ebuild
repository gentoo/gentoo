# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Generate the IBus GTK or GNOME Shell theme from existing themes"
HOMEPAGE="
	https://pypi.org/project/ibus-theme-tools/
	https://github.com/openSUSE/IBus-Theme-Tools
"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/openSUSE/IBus-Theme-Tools/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	sys-devel/gettext
	dev-python/tinycss2[${PYTHON_USEDEP}]
"
