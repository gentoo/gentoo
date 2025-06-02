# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="COmputer Language Manipulation"
HOMEPAGE="https://www.colm.net/open-source/colm/"
SRC_URI="https://www.colm.net/files/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

BDEPEND="
	doc? (
		|| ( app-text/asciidoc dev-ruby/asciidoctor )
		dev-python/pygments
	)
"
# libfsm moved from ragel -> colm, bug #766108
RDEPEND="!<dev-util/ragel-7.0.3"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.7-drop-julia-check.patch
	"${FILESDIR}"/${PN}-0.14.7-disable-static-lib.patch
	"${FILESDIR}"/${PN}-0.14.7-solaris.patch
	# https://bugs.gentoo.org/927974
	"${FILESDIR}"/${PN}-0.14.7-slibtool.patch
)

src_prepare() {
	default

	# bug #733426
	sed -i -e 's/(\[ASCIIDOC\], \[asciidoc\], \[asciidoc\]/S([ASCIIDOC], [asciidoc asciidoctor]/' configure.ac || die

	# Respect CC/CXX (bug #766069), we also omit CFLAGS here because
	# it seems to crash with some combinations and the software is fragile
	# (bug #883993).
	sed -i -e "s|gcc|$(tc-getCC)|" src/main.cc || die
	sed -i -e "s|gcc|$(tc-getCC)|" test/colm.d/gentests.sh || die
	sed -i -e "s|g++|$(tc-getCXX)|" test/colm.d/gentests.sh || die

	# fix linkage on Darwin from colm itself during build
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/libcolm\.so/libcolm.dylib/' src/main.cc || die
	fi

	# Test fails w/ modern C (bug #944324)
	rm test/colm.d/ext1.lm || die

	eautoreconf
}

src_configure() {
	# We need to be careful with both ragel and colm.
	# See bug #858341, bug #883993 bug #924163.
	filter-lto
	append-flags -fno-strict-aliasing

	# bug #944324
	append-cflags -std=gnu89

	# bug #924163
	append-lfs-flags

	econf $(use_enable doc manual)
}

src_test() {
	# Build tests
	default

	# Run them (and make sure we use just-built libraries, bug #941565)
	local -x LD_LIBRARY_PATH="${S}/src/.libs:${S}/src:${LD_LIBRARY_PATH}"
	cd test || die
	./runtests || die
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
