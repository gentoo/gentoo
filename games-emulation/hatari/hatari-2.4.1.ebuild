# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Atari ST emulator"
HOMEPAGE="https://hatari.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/hatari/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X capsimage gui png portmidi readline udev zlib"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	png? ( zlib )"

COMMON_DEPEND="
	media-libs/libsdl2[X?,joystick,sound,video]
	X? ( x11-libs/libX11 )
	capsimage? ( >=dev-libs/spsdeclib-5.1-r1 )
	png? ( media-libs/libpng:= )
	portmidi? ( media-libs/portmidi )
	readline? ( sys-libs/readline:= )
	udev? ( virtual/udev )
	zlib? ( sys-libs/zlib:= )"
RDEPEND="
	${PYTHON_DEPS}
	${COMMON_DEPEND}
	gui? (
		$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		x11-libs/gtk+:3[introspection]
	)
	>=games-emulation/emutos-1.1.1"
DEPEND="
	${COMMON_DEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.1-caps5-include-path.patch
	"${FILESDIR}"/${PN}-2.3.1-cmake-include-checksym.patch
)

DOCS=(
	readme.txt
	doc/{bugs,changelog,scsi-driver,thanks,video-recording}.txt
)

src_prepare() {
	cmake_src_prepare

	sed -i "s/\.1\.gz\b/.1/;T;s/gzip[^\$]*/cat /" {*/,}*/CMakeLists.txt || die
	sed -i "s:doc/${PN}:doc/${PF}/html:" python-ui/uihelpers.py || die
	sed -e "s/python3/${EPYTHON}/" \
		-e 's/mkdosfs/mkfs.fat/' \
		-i tools/atari-hd-image.sh || die

	# use emutos package rather than bundled ROM
	rm src/tos.img || die
	cat <<-EOF > hatari.cfg || die
		[ROM]
		szTosImageFileName = ${EPREFIX}/usr/share/emutos/etos1024k.img
	EOF
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DDOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
		-DETCDIR="${EPREFIX}"/etc
		$(cmake_use_find_package X X11)
		$(cmake_use_find_package capsimage CapsImage)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package portmidi PortMidi)
		$(cmake_use_find_package readline Readline)
		$(cmake_use_find_package udev Udev)
		$(cmake_use_find_package zlib ZLIB)
		$(usev !gui -DPYTHON_EXECUTABLE=false) # only disables python-ui/
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc
	doins hatari.cfg

	mv "${ED}"/usr/share/doc/${PF}/{html/*.txt,} || die

	python_fix_shebang "${ED}"/usr/bin
	use gui && python_fix_shebang "${ED}"/usr/share/${PN}/${PN}ui
}
