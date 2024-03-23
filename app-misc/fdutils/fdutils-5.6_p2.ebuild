# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}_5.6

inherit autotools toolchain-funcs

DESCRIPTION="Utilities for configuring and debugging the Linux floppy driver"
HOMEPAGE="https://fdutils.linux.lu"
SRC_URI="
	mirror://debian/pool/main/f/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/f/${PN}/${MY_P}-2.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=sys-fs/mtools-4"
DEPEND="${RDEPEND}
	virtual/os-headers
"
BDEPEND="
	sys-apps/texinfo
	dev-build/autoconf-archive
	doc? ( virtual/texi2dvi )
"

S="${WORKDIR}/${PN}-5.6"

src_prepare() {
	local debian=($(< "${WORKDIR}"/debian/patches/series)) || die
	debian=(${debian[@]/fdmount-compilation_linux_2.6.patch/}) # exclude this patch
	PATCHES+=("${debian[@]/#/${WORKDIR}/debian/patches/}")
	PATCHES+=(
		"${FILESDIR}"/fdutils-5.5.20060227-r1-parallel.patch # bug 315577
		"${FILESDIR}"/fdutils-5.6_p2-parallel.patch
		"${FILESDIR}"/fdutils-5.6_p2-docs-build.patch
		"${FILESDIR}"/fdutils-5.6_p2-variable-ar.patch
	)

	default

	eautoreconf
	touch ar-lib || die # bug 834874
}

src_configure() {
	export CC_FOR_BUILD="$(tc-getBUILD_CC)"

	econf --enable-fdmount-floppy-only
}

src_compile() {
	emake
	use doc && emake doc
}

src_install() {
	dodir /etc
	emake DESTDIR="${D}" install
	emake -C doc DESTDIR="${D}" install-man

	use doc && emake DESTDIR="${D}" install-doc

	# The copy in sys-apps/man-pages is more recent
	rm -f "${ED}"/usr/share/man/man4/fd.4 || die

	# Rename to match binary
	mv "${ED}"/usr/share/man/man1/{makefloppies,MAKEFLOPPIES}.1 || die
}
