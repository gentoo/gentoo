# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A command-line tool for taking JPEG snapshots of VNC servers"
HOMEPAGE="http://vncsnapshot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

DEPEND="
	virtual/jpeg
	>=sys-libs/zlib-1.1.4"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-amd64grey.patch"
)

src_prepare() {
	default

	sed \
		-e 's:-I/usr/local/include::g' \
		-e 's:-L/usr/local/lib::g' \
		-e '/^all:/s|$(SUBDIRS:.dir=.all)||g' \
		-e '/^vnc/s|$| $(SUBDIRS:.dir=.all)|g' \
		-i Makefile || die

	# Preserve make instance
	sed -i -e 's/make/$(MAKE)/' Makefile || die

	# Respect RANLIB
	sed -i -e 's/ranlib/$(RANLIB)/' rdr/Makefile || die
}

src_compile() {
	# Note: We override CDEBUGFLAGS instead of CFLAGS because otherwise
	#       we lose the INCLUDES in the makefile.
	# bug #295741
	local args=(
		AR="$(tc-getAR)"
		CDEBUGFLAGS="${CXXFLAGS}"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		RANLIB="$(tc-getRANLIB)"
	)
	emake "${args[@]}"
}

src_install() {
	dobin vncsnapshot

	cp vncsnapshot.man1 vncsnapshot.1 || die
	doman vncsnapshot.1
}
