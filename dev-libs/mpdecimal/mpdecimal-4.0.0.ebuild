# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Correctly-rounded arbitrary precision decimal floating point arithmetic"
HOMEPAGE="https://www.bytereef.org/mpdecimal/"
SRC_URI="
	https://www.bytereef.org/software/mpdecimal/releases/${P}.tar.gz
	test? (
		https://speleotrove.com/decimal/dectest.zip
	)
"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="cxx test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-arch/unzip
	)
"

src_unpack() {
	unpack "${P}.tar.gz"
	if use test; then
		mkdir "${P}/tests/testdata" || die
		cd "${P}/tests/testdata" || die
		unpack dectest.zip
	fi
}

src_prepare() {
	default

	# sigh
	sed -i -e "s:/lib:/$(get_libdir):" lib*/.pc/*.pc.in || die
}

src_configure() {
	local myconf=(
		# just COPYRIGHT.txt
		--docdir=/removeme
		$(use_enable cxx)
	)

	# more sigh
	# https://bugs.gentoo.org/931599
	local -x LDXXFLAGS="${LDFLAGS}" LD="${CC}" LDXX="${CXX}"
	econf "${myconf[@]}"
}

src_test() {
	emake check
}

src_install() {
	default
	rm -r "${D}/removeme" || die
}
