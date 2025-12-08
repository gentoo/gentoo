# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing

if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/legionus/kbd.git https://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git"
	EGIT_BRANCH="master"
else
	if [[ $(ver_cut 3) -lt 90 ]] ; then
		SRC_URI="https://www.kernel.org/pub/linux/utils/kbd/${P}.tar.xz"
		KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
	else
		inherit autotools
		SRC_URI="https://github.com/legionus/kbd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="Keyboard and console utilities"
HOMEPAGE="https://kbd-project.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls selinux pam test"
RESTRICT="!test? ( test )"

DEPEND="
	app-alternatives/gzip
	pam? (
		!app-misc/vlock
		sys-libs/pam
	)
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-loadkeys )
"
BDEPEND="
	sys-devel/flex
	virtual/pkgconfig
	test? ( dev-libs/check )
"

src_prepare() {
	default

	# Rename conflicting keymaps to have unique names, bug #293228
	# See also https://github.com/legionus/kbd/issues/76.
	pushd "${S}"/data/keymaps/i386 &> /dev/null || die
	mv fgGIod/trf.map fgGIod/trf-fgGIod.map || die
	mv olpc/es.map olpc/es-olpc.map || die
	mv olpc/pt.map olpc/pt-olpc.map || die
	mv qwerty/cz.map qwerty/cz-qwerty.map || die
	popd &> /dev/null || die

	if [[ ${PV} == 9999 ]] || [[ $(ver_cut 3) -ge 90 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	# https://github.com/legionus/kbd/issues/121
	unset LEX

	local myeconfargs=(
		--disable-werror

		$(use_enable nls)
		$(use_enable pam vlock)
		$(use_enable test tests)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# These tests want a tty and the check passes when it shouldn't
	# when running via the ebuild.
	sed -i -e "s:tty 2>/dev/null:false:" tests/testsuite || die

	# Workaround Valgrind being mandatory for tests
	# https://github.com/legionus/kbd/issues/133 (bug #956964)
	#
	# XXX: Drop this on next release (>2.8.0) and replace with
	# --disable-memcheck in configure.
	cat <<-EOF > tests/valgrind.sh || die
	#!/bin/sh
	shift
	exec "\$@" 1>stdout 2>stderr
	EOF
	chmod +x tests/valgrind.sh || die

	emake -Onone check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}

src_install() {
	default

	# USE="test" installs .la files
	find "${ED}" -type f -name "*.la" -delete || die
}
