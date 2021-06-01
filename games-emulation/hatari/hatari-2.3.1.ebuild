# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Atari ST emulator"
HOMEPAGE="https://hatari.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/hatari/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="capsimage gui microphone png portmidi readline udev zlib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	media-libs/libsdl2[sound,video]
	capsimage? ( >=dev-libs/spsdeclib-5.1-r1 )
	microphone? ( media-libs/portaudio )
	png? ( media-libs/libpng:= )
	portmidi? ( media-libs/portmidi )
	readline? ( sys-libs/readline:= )
	udev? ( virtual/udev )
	zlib? ( sys-libs/zlib:= )"
RDEPEND="
	${DEPEND}
	gui? (
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
		x11-libs/gtk+:3[introspection]
	)
	>=games-emulation/emutos-0.9.9.1"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-caps5-include-path.patch
	"${FILESDIR}"/${P}-cmake-include-checksym.patch
)
DOCS=(
	readme.txt
	doc/{bugs,changelog,scsi-driver,thanks,video-recording}.txt
)

src_prepare() {
	cmake_src_prepare

	sed -i "s/\.1\.gz\b/.1/g;T;s/gzip[^\$]*/cat /g" {*/,}*/CMakeLists.txt || die
	sed -i "s:doc/${PN}:doc/${PF}:" python-ui/uihelpers.py || die
	# Note: >2.3.1 renames /python/ to /python3/, update accordingly
	sed -i "s/python/${EPYTHON}/;s/dosfs/fs.fat/" tools/atari-hd-image.sh || die

	# Use emutos package rather than bundled ROM.
	rm src/tos.img || die
	cat <<-EOF > hatari.cfg || die
		[ROM]
		szTosImageFileName = ${EPREFIX}/usr/share/emutos/etos512k.img
	EOF
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_CapsImage=$(usex !capsimage)
		-DCMAKE_DISABLE_FIND_PACKAGE_PNG=$(usex !png)
		-DCMAKE_DISABLE_FIND_PACKAGE_PortAudio=$(usex !microphone)
		-DCMAKE_DISABLE_FIND_PACKAGE_PortMidi=$(usex !portmidi)
		-DCMAKE_DISABLE_FIND_PACKAGE_Readline=$(usex !readline)
		-DCMAKE_DISABLE_FIND_PACKAGE_Udev=$(usex !udev)
		-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=$(usex !zlib)
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}
		-DETCDIR="${EPREFIX}"/etc
		$(usex gui '' -DPYTHON_EXECUTABLE=false) # disables python-ui/
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc
	doins hatari.cfg

	python_fix_shebang "${ED}"/usr/bin
	use gui && python_fix_shebang "${ED}"/usr/share/${PN}/${PN}ui
}
