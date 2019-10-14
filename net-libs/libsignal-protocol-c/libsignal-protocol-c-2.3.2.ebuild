# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib cmake-utils

DESCRIPTION="Signal Protocol C Library"
HOMEPAGE="https://www.whispersystems.org/"
SRC_URI="https://github.com/signalapp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"
