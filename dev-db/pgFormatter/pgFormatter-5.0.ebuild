# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="PostgreSQL SQL syntax beautifier"
HOMEPAGE="https://github.com/darold/pgFormatter"
SRC_URI="https://github.com/darold/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
