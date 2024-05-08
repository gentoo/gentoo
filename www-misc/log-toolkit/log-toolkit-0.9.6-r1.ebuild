# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit depend.apache

DESCRIPTION="set of tools to manipulate and maintain webserver logfiles"
HOMEPAGE="https://sourceforge.net/projects/log-toolkit/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

need_apache
