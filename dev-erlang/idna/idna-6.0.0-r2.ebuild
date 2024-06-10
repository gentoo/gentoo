# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Erlang IDNA implementation"
HOMEPAGE="https://github.com/benoitc/erlang-idna"
SRC_URI="https://github.com/benoitc/erlang-idna/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/erlang-idna-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"

DEPEND=">=dev-lang/erlang-21.0"

# Removes dependency to workaround for older erlang versions.
# Patch based on https://github.com/benoitc/erlang-idna/pull/31
PATCHES=( "${FILESDIR}/0001-Remove-dependency-on-unicode_util_compat.patch" )
