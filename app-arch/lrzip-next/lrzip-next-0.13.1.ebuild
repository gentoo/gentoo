# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="Fork of Con Kolivas' lrzip program for compressing large files"
HOMEPAGE="https://github.com/pete4abw/lrzip-next"

GH_BASE="https://github.com/pete4abw/lrzip-next"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="${GH_BASE}.git"
else
	SRC_URI="${GH_BASE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="asm +largefile static-libs year2038"

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

	eapply "${FILESDIR}/${PN}-0.13.1-fix-lzma_asm_makefile-echo.patch"
	eapply "${FILESDIR}/${PN}-0.13.1-use-acx_pthread-configure_ac.patch"

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
		$(use_enable amd64 asm)
		$(use_enable largefile) \
		$(use_enable static-libs static)
	)

	# This configure switch only appears on glibc-based userlands.
	# It enables 64-bit time_t to support timestamps greater than
	# the year 2038 (D_TIME_BITS=64).
	if use elibc_glibc; then
		myconf+=( $(use_enable year2038) )
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
}
