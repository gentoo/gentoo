# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Elixir programming language"
HOMEPAGE="https://elixir-lang.org"
SRC_URI="https://github.com/elixir-lang/elixir/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 ErlPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~riscv ~sparc ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

# https://hexdocs.pm/elixir/compatibility-and-deprecations.html#between-elixir-and-erlang-otp
DEPEND="
	>=dev-lang/erlang-24:0=[ssl]
	<dev-lang/erlang-27
"
# 'mix' tool collides with sci-biology/phylip, bug #537514
RDEPEND="${DEPEND}
	!!sci-biology/phylip
"
DEPEND+="
	test? ( dev-vcs/git )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.1-disable-network-tests.patch
	"${FILESDIR}"/${PN}-1.10.3-no-Q.patch
	"${FILESDIR}"/${PN}-1.10.3-epmd-daemon.patch
)

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="${EPREFIX}/usr" install
	dodoc README.md CHANGELOG.md CODE_OF_CONDUCT.md
}
