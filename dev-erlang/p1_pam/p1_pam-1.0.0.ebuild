# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rebar

MY_PN="epam"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="epam for ejabberd to help with PAM authentication support"
HOMEPAGE="https://github.com/processone/epam"
SRC_URI="https://github.com/processone/${MY_PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-lang/erlang-17.1"
RDEPEND="${DEPEND}"

DOCS=( README.md )

S="${WORKDIR}/${MY_P}"
