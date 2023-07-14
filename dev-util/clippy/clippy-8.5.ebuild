# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="frr-${PV}"
PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-single-r1

DESCRIPTION="Standalone clippy tool built from FRR sources"
HOMEPAGE="https://frrouting.org/"
SRC_URI="https://github.com/FRRouting/frr/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/frr-${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# standalone clippy does not have any tests
# restrict to prevent bug 811753
RESTRICT="test"

DEPEND="
	${PYTHON_DEPS}
	virtual/libelf:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

QA_CONFIG_IMPL_DECL_SKIP=(
	mallinfo	# check in configure is fallback is needed
	mallinfo2	# check in configure is fallback is needed
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #884291
	unset YACC
	export LEX=flex

	econf --enable-clippy-only
}

src_install() {
	# 830087
	find "lib" -type f -name "clippy" -print0 |
		xargs -0 file | grep executable | grep ELF | cut -f 1 -d : |
		xargs -I '{}' dobin '{}' ||
		die "Failed to install 'lib/clippy'"
}
