# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Meta package for dev-util/molecule-core and dev-util/molecule-plugins"
HOMEPAGE="https://www.sabayon.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins"

DEPEND=""
RDEPEND=">=dev-util/molecule-core-1.0.2
	plugins? ( >=dev-util/molecule-plugins-1.0.2 )"
