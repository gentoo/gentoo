# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="Fork of Con Kolivas' lrzip program for compressing large files"
HOMEPAGE="https://github.com/pete4abw/lrzip-next"
SRC_URI="https://github.com/pete4abw/lrzip-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="asm static-libs year2038"

RDEPEND="app-arch/bzip2
	app-arch/bzip3
	app-arch/lz4
	app-arch/zstd
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	dev-libs/lzo
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="amd64? ( dev-lang/nasm )"

src_prepare() {
	default

	# configure.ac uses a small helper script, ./util/gitdesc.sh, to
	# see if it's a tarball or git repo copy.  If tarball, it extracts
	# the version information from a local VERSION file and puts it into
	# configure.ac at the top for major/minor/micro.  To avoid the need
	# for a BDEPEND on dev-vcs/git, we can do this directly.
	local major=$(awk '/Major: / {printf "%s",$2; exit}' VERSION)
	local minor=$(awk '/Minor: / {printf "%s",$2; exit}' VERSION)
	local micro=$(awk '/Micro: / {printf "%s",$2; exit}' VERSION)
	sed -i -e "s:\[m4_esyscmd_s(\[./util/gitdesc.sh major\])\]:${major}:" configure.ac
	sed -i -e "s:\[m4_esyscmd_s(\[./util/gitdesc.sh minor\])\]:${minor}:" configure.ac
	sed -i -e "s:\[m4_esyscmd_s(\[./util/gitdesc.sh micro\])\]:${micro}:" configure.ac

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable static-libs static) \
		$(use_enable amd64 asm)
	)

	# This configure switch disappears on a musl system for some
	# reason.  However, this package is currently broken on musl,
	# but we'll leave this in place while we see if upstream has
	# any advice.
	if ! use elibc_musl; then
		myconf+=( $(use_enable year2038) )
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
