# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rebar

DESCRIPTION="Erlang IDNA implementation"
HOMEPAGE="https://github.com/benoitc/erlang-idna"
SRC_URI="https://github.com/benoitc/erlang-idna/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc"

DEPEND=">=dev-lang/erlang-21.0"

DOCS=( CHANGELOG README.md )

S="${WORKDIR}/erlang-idna-${PV}"

# Removes dependency to workaround for older erlang versions.
# Patch from https://github.com/benoitc/erlang-idna/pull/31
PATCHES=( "${FILESDIR}/idna-remove-unicode_util_compat.diff" )
