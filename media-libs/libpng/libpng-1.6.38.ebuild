# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
SRC_URI+=" apng? ( mirror://sourceforge/libpng-apng/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2))/${PV}/${P}-apng.patch.gz )"

LICENSE="libpng2"
SLOT="0/16"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="apng cpu_flags_arm_neon cpu_flags_x86_sse static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( ANNOUNCE CHANGES libpng-manual.txt README TODO )

src_prepare() {
	default

	if use apng; then
		eapply "${WORKDIR}"/${PN}-*-apng.patch

		# Don't execute symbols check with apng patch, bug #378111
		sed -i -e '/^check/s:scripts/symbols.chk::' Makefile.in || die
	fi

	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_arm_neon arm-neon)
		$(use_enable cpu_flags_x86_sse intel-sse)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default

	find "${ED}" \( -type f -o -type l \) -name '*.la' -delete || die
}
