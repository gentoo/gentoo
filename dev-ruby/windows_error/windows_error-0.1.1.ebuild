# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23"

inherit ruby-fakegem versionator

DESCRIPTION="reference for standard Windows API Error Codes"
HOMEPAGE="https://github.com/rapid7/windows_error"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
RESTRICT=test
IUSE=""
