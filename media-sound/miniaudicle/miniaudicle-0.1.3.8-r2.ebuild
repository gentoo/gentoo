# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/miniaudicle/miniaudicle-0.1.3.8-r2.ebuild,v 1.4 2015/03/31 19:41:58 ulm Exp $

EAPI=5
WX_GTK_VER=2.8
inherit eutils toolchain-funcs flag-o-matic wxwidgets

MY_P="${P/a/A}"

DESCRIPTION="integrated development + performance environment for chuck"
HOMEPAGE="http://audicle.cs.princeton.edu/mini/"
SRC_URI="http://audicle.cs.princeton.edu/mini/release/files/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+alsa jack oss"

RDEPEND="jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( >=media-libs/alsa-lib-0.9 )
	media-libs/libsndfile
	>=x11-libs/gtk+-2.10:2
	x11-libs/wxGTK:2.8[X]
	app-eselect/eselect-miniaudicle"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="|| ( alsa jack oss )"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-hid-smc.patch" \
		"${FILESDIR}/${P}-gcc44.patch" \
		"${FILESDIR}/${P}-void-to-int-cast.patch"

	sed -i -e 's/make -C/#make -C/' \
		-e 's/g++/$(CXX)/' \
		-e 's/-O3 -c/-c $(CFLAGS)/' \
		-e 's/$(LIBS)/$(LDFLAGS) $(LIBS)/' \
		makefile.* || die "sed failed"

	# Respect LDFLAGS in bundled media-sound/chuck
	# prevent underlinking with pthreads library
	sed -i -e 's/$(LIBS)/$(LDFLAGS) $(LIBS) -lpthread/' \
		chuck/src/makefile.* || die "sed failed"

	epatch_user
}

compile_backend() {
	local backend="$1"
	einfo "Compiling against ${backend}"
	cd "${S}/chuck/src"
	emake -f "makefile.${backend}" CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)"
	cd "${S}"
	emake -f "makefile.${backend}" CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)"
	mv wxw/miniAudicle{,-${backend}}
	emake -f "makefile.${backend}" clean
	cd "${S}/chuck/src"
	emake -f "makefile.${backend}" clean
}

src_compile() {
	# when compiled with -march=athlon or -march=athlon-xp
	# miniaudicle crashes on removing a shred with a double free or corruption
	# it happens in Chuck_VM_Stack::shutdown() on the line
	#   SAFE_DELETE_ARRAY( stack );
	replace-cpu-flags athlon athlon-xp i686

	use jack && compile_backend jack
	use alsa && compile_backend alsa
	use oss && compile_backend oss
}

src_install() {
	use jack && dobin wxw/miniAudicle-jack
	use alsa && dobin wxw/miniAudicle-alsa
	use oss && dobin wxw/miniAudicle-oss
	dodoc BUGS README.linux VERSIONS
}

pkg_postinst() {
	elog "miniAudicle now can use many audio engines, so you can specify audio engine"
	elog "with miniAudicle-{jack,alsa,oss}"
	elog "Or you can use 'eselect miniaudicle' to set the audio engine"

	einfo "Calling eselect miniaudicle update..."
	eselect miniaudicle update --if-unset
}
