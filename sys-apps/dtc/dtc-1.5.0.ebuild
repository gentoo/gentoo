# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib toolchain-funcs eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/utils/dtc/dtc.git"
	inherit git-r3
else
	SRC_URI="https://www.kernel.org/pub/software/utils/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

DESCRIPTION="Open Firmware device tree compiler"
HOMEPAGE="https://devicetree.org/ https://git.kernel.org/cgit/utils/dtc/dtc.git/"

LICENSE="GPL-2"
SLOT="0"
IUSE="static-libs"

DEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
DOCS="
	Documentation/dt-object-internal.txt
	Documentation/dts-format.txt
	Documentation/manual.txt
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.4-posix-shell.patch
	"${FILESDIR}"/${PN}-1.5.0-fdt_check_full-visibility.patch
	"${FILESDIR}"/${PN}-1.5.0-gcc-10.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS =/s:=:+=:' \
		-e '/^CPPFLAGS =/s:=:+=:' \
		-e 's:-Werror::' \
		-e 's:-g -Os::' \
		-e "/^PREFIX =/s:=.*:= ${EPREFIX}/usr:" \
		-e "/^LIBDIR =/s:=.*:= \$(PREFIX)/$(get_libdir):" \
		Makefile || die

	tc-export AR CC PKG_CONFIG
	export V=1
}

src_install() {
	default

	use static-libs || find "${ED}" -name '*.a' -delete
}
