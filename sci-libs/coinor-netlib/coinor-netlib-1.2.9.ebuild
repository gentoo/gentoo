# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR netlib models"
HOMEPAGE="https://projects.coin-or.org/svn/Data/Netlib/"
SRC_URI="https://github.com/coin-or-tools/Data-Netlib/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Data-Netlib-releases-${PV}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
