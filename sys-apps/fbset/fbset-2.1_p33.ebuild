# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MyPV=$(ver_cut 1-2)

DESCRIPTION="A utility to set the framebuffer videomode"
HOMEPAGE="http://users.telenet.be/geertu/Linux/fbdev/"
SRC_URI="http://users.telenet.be/geertu/Linux/fbdev/${PN}-${MyPV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

PATCHES=(
	"${FILESDIR}/${PN}-2.1-add-linux-types-h.patch"
)

DOCS=( # etc/fb.modes.ATI gets installed as /etc/fb.modes
	INSTALL etc/fb.modes.{Falcon,NTSC,PAL}
	"${WORKDIR}/debian/"{doc/FAQ,modes/fb.modes.{ATI+{LG,Samsung},CyBla,openmoko,viafb}}
)

S="${WORKDIR}/${PN}-${MyPV}"

src_prepare() {
	local -a debian_patches
	mapfile -t debian_patches <"${WORKDIR}/debian/patches/series"
	eapply "${debian_patches[@]/#/${WORKDIR}/debian/patches/}"

	default

	sed -e '/^\(CC\|CFLAGS\) =/d' -i Makefile || die

	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=995822
	sed -e 's/\(fbset\( "\)\?(\)8/\11/' -i fb.modes.5 modeline2fb || die
}

src_configure() {
	use static && append-ldflags -static
	export CC="$(tc-getCC)"
}
