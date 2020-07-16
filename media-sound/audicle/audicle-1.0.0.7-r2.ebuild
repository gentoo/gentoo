# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A Context-sensitive, On-the-fly Audio Programming Environ/mentality"
HOMEPAGE="http://audicle.cs.princeton.edu/"
SRC_URI="http://audicle.cs.princeton.edu/release/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa jack oss truetype"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
DEPEND="
	app-eselect/eselect-audicle
	media-libs/freeglut
	media-libs/libsndfile
	virtual/opengl
	virtual/glu
	x11-libs/gtk+:2
	alsa? ( >=media-libs/alsa-lib-0.9 )
	jack? ( virtual/jack )
	truetype? (
		media-fonts/corefonts
		media-libs/ftgl
	)
"
rDEPEND="${DEPEND}"

REQUIRED_USE="|| ( alsa jack oss )"

DOCS=( AUTHORS PROGRAMMER README THANKS TODO VERSIONS )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0.6-font.patch"
	"${FILESDIR}/${P}-hid-smc.patch"
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-const.patch"
)

src_prepare() {
	default

	sed -i \
		-e 's@../ftgl_lib/FTGL/include@/usr/include/FTGL@' \
		-e 's@../ftgl_lib/FTGL/mac/build@/usr/lib@' \
		-e 's/gcc -o/$(CC) -o/' \
		-e 's/-O3 -c/-c $(CFLAGS)/' \
		-e 's/$(LIBS)/$(LDFLAGS) $(LIBS)/' \
		src/makefile.{alsa,jack,oss} || die "sed failed"
}

compile_backend() {
	local backend="$1"
	local config
	use truetype && config="USE_FREETYPE_LIBS=1"
	einfo "Compiling against ${backend}"
	cd "${S}/src"
	emake -f "makefile.${backend}" CC="$(tc-getCC)" CXX="$(tc-getCXX)" LEX=flex \
		YACC=bison ${config}
	mv audicle{,-${backend}}
	emake -f makefile clean
}

src_compile() {
	# when compile with athlon or athlon-xp flags
	# audicle crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	use jack && compile_backend jack
	use alsa && compile_backend alsa
	use oss && compile_backend oss
}

src_install() {
	use jack && dobin src/audicle-jack
	use alsa && dobin src/audicle-alsa
	use oss && dobin src/audicle-oss
	dodoc ${DOCS[@]}
}

pkg_postinst() {
	elog "Audicle now can use many audio engines, so you can specify audio engine"
	elog "with audicle-{jack,alsa,oss}"
	elog "Or you can use 'eselect audicle' to set the audio engine"

	einfo "Calling eselect audicle update..."
	eselect audicle update --if-unset
}
