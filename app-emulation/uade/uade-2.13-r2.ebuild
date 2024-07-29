# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unix Amiga Delitracker Emulator - plays old Amiga tunes through UAE emulation"
HOMEPAGE="https://zakalwe.fi/uade"
SRC_URI="https://zakalwe.fi/uade/uade2/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="fuse"

RDEPEND="
	media-libs/libao
	fuse? ( sys-fs/fuse:0 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
)

DOCS=( AUTHORS ChangeLog doc/BUGS doc/PLANS )

src_prepare() {
	default

	# needed to avoid ${D} VariableScope undefined behavior in src_configure
	find . -name Makefile.in -exec sed -i 's|{PACKAGEPREFIX}|$(DESTDIR)|' {} + || die
}

src_configure() {
	tc-export CC

	# not autotools generated
	local configure=(
		./configure
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--with-text-scope
		--without-audacious
		--without-xmms
		$(use_with fuse uadefs)
		${EXTRA_ECONF}
	)
	echo ${configure[*]}
	"${configure[@]}" || die
}
