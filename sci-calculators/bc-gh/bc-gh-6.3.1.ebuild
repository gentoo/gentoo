# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="bc-${PV}"
DESCRIPTION="Implementation of POSIX bc with GNU extensions"
HOMEPAGE="
	https://git.gavinhoward.com/gavin/bc/
	https://github.com/gavinhoward/bc/
"
SRC_URI="
	https://github.com/gavinhoward/bc/releases/download/${PV}/${MY_P}.tar.xz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="libedit readline"

DEPEND="
	!readline? (
		libedit? ( dev-libs/libedit:= )
	)
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local myconf=(
		# GNU and BSD bc's have slightly different behavior. This bc can act
		# like both, changing at runtime with environment variables, but it
		# needs defaults, which can be set at compile time. This option sets all
		# of the defaults to match the GNU bc/dc since it's common on Linux.
		-pGNU
		# A lot of test results are generated first by a bc compatible with the
		# GNU bc. If there is no GNU bc installed, then those tests should be
		# skipped. That's what this option does. Without it, we would have a
		# dependency cycle. Those tests are super long, anyway.
		-G
		# Disables the automatic stripping of binaries.
		-T
		# Enables installing all locales, which is important for packages.
		-l
		# Disables some "problematic" tests that need specific options on Linux
		# to not trigger the OOM killer because malloc() lies.
		-P
	)
	if use readline ; then
		myconf+=( -r )
	elif use libedit ; then
		myconf+=( -e )
	fi

	local -x EXECSUFFIX="-gh"
	local -x PREFIX="${EPREFIX}/usr"
	./configure.sh "${myconf[@]}" || die
}

src_test() {
	# This is to fix a bug encountered on Arch. It is to ensure we don't get
	# segfaults on `make check` when the error messages change because the error
	# messages are passed to printf(); they have format specifiers. With these
	# env vars, the internal error messages are used, instead of the installed
	# locales, which might be different since the new locale files are not
	# installed yet. (It is impossible to use uninstalled locales because of the
	# poor design of POSIX locales.)
	env LANG=C LC_ALL=C emake check
}
