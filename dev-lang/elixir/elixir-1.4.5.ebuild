# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Elixir programming language"
HOMEPAGE="https://elixir-lang.org"
SRC_URI="https://github.com/elixir-lang/elixir/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 ErlPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/erlang-18[ssl]"
RDEPEND="${DEPEND}"

src_compile() {
	emake Q=""
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="/usr" install
	dodoc README.md CHANGELOG.md CODE_OF_CONDUCT.md
}
