# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="CUE Sheet Parser Library"
HOMEPAGE="https://github.com/lipnitsk/libcue"
SRC_URI="https://github.com/lipnitsk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~sh sparc x86"
IUSE=""

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
