# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

REBAR_APP_SRC=src/p1_pam.app.src

inherit rebar

DESCRIPTION="epam for ejabberd to help with PAM authentication support"
HOMEPAGE="https://github.com/processone/epam"
SRC_URI="https://github.com/processone/epam/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ~sparc x86"

DEPEND=">=dev-lang/erlang-17.1
	sys-libs/pam"
RDEPEND="${DEPEND}"

DOCS=( README.md )
