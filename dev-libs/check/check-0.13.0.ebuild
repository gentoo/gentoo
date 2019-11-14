# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A unit test framework for C"
HOMEPAGE="https://libcheck.github.io/check/"
SRC_URI="https://github.com/lib${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs subunit test"

# https://github.com/libcheck/check/issues/208
RESTRICT="test"
#RESTRICT="!test? ( test )"

RDEPEND="subunit? ( dev-python/subunit[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		$(use_enable doc build-docs)
		$(use_enable subunit)
		$(use_enable test timeout-tests)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default
}

src_compile() {
	if use doc; then
		cd doc/ || die "Failed to switch directories."
		doxygen "." || die "Failed to run doxygen to generate docs."
	fi
}

multilib_src_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	default

	rm -r "${ED}/usr/share/doc/check/" || die "Failed to remove COPYING* files"
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
