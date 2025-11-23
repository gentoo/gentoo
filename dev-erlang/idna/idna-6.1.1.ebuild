# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rebar

DESCRIPTION="Erlang IDNA implementation"
HOMEPAGE="https://github.com/benoitc/erlang-idna"
SRC_URI="
	https://github.com/benoitc/erlang-idna/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/benoitc/erlang-idna/commit/230a9175a5edb1b1a47fb09af2f4341eab93b1b0.patch
		-> idna-6.1.1-remove-unicode_util_compat.patch
"
S="${WORKDIR}/erlang-idna-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"

DEPEND=">=dev-lang/erlang-21.0"

PATCHES=(
	"${DISTDIR}"/idna-6.1.1-remove-unicode_util_compat.patch
)
