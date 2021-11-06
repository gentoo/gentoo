# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/cgdb/cgdb.git"
	inherit git-r3
else
	SRC_URI="https://github.com/cgdb/cgdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

inherit autotools multilib-minimal

DESCRIPTION="A curses front-end for GDB, the GNU debugger"
HOMEPAGE="https://cgdb.github.io/"
LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:0="
RDEPEND="${DEPEND}
	sys-devel/gdb"

BDEPEND="
	test? (
		dev-util/dejagnu
		app-misc/dtach
	)"

DOCS=( AUTHORS ChangeLog FAQ INSTALL NEWS README.md )

PATCHES=(
	# Bug: #724256
	"${FILESDIR}/${P}-respect-AR.patch"
)

src_prepare() {
	default
	AT_M4DIR="config" eautoreconf
}

multilib_src_test() {
	# Tests need an interactive shell, #654986

	# real-time output of the log ;-)
	touch "${T}/dtach-test.log" || die
	tail -f "${T}/dtach-test.log" &
	local tail_pid=${!}

	nonfatal dtach -N "${T}/dtach.sock" \
		bash -c 'emake check &> "${T}"/dtach-test.log; echo ${?} > "${T}"/dtach-test.out'

	kill "${tail_pid}"
	[[ -f ${T}/dtach-test.out ]] || die "Unable to run tests"
	[[ $(<"${T}"/dtach-test.out) == 0 ]] || die "Tests failed"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}
