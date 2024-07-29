# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rebar

DESCRIPTION="epam for ejabberd to help with PAM authentication support"
HOMEPAGE="https://github.com/processone/epam"
SRC_URI="https://github.com/processone/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 ~sparc ~x86"

DEPEND="
	acct-group/epam
	>=dev-lang/erlang-17.1
	sys-libs/pam
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md README.md )

src_install() {
	rebar_src_install

	local epam_path="$(get_erl_libs)/${P}/priv/bin/epam"
	fowners root:"${PN}" "${epam_path}"
	fperms 4750 "${epam_path}"
}
