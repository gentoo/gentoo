# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementation of the EWF (SMART and EnCase) image format"
HOMEPAGE="https://github.com/libyal/libewf"
SRC_URI="https://github.com/libyal/libewf/releases/download/${PV}/${PN}-experimental-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 ~riscv x86"
# Upstream bug #2597171, pyewf has implicit declarations
#IUSE="debug python unicode"
IUSE="bfio bzip2 debug +fuse nls +ssl static-libs +uuid unicode zlib"

# Uses bundled libbfio until tree version is bumped
RDEPEND="
	bzip2? ( app-arch/bzip2 )
	fuse? ( sys-fs/fuse:0= )
	nls? (
		virtual/libintl
		virtual/libiconv
	)
	uuid? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

# Issues finding test executables
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-openssl-3.patch
)

src_configure() {
	local econfargs=(
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable debug verbose-output)
		$(use_enable debug debug-output)
		$(use_enable unicode wide-character-type)
		$(use_with bfio libbfio)
		$(use_with zlib)
		$(use_with bzip2)
		$(use_with ssl openssl)
		$(use_with uuid libuuid)
		$(use_with fuse libfuse)
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}"/usr -name '*.la' -delete || die
	fi
}
