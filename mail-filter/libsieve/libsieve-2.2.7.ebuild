# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library for parsing, sorting and filtering your mail"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libsieve.sourceforge.net/"

SLOT="0"
LICENSE="MIT LGPL-2.1"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="!<net-mail/mailutils-2.1"

S=${WORKDIR}/${P}/src
