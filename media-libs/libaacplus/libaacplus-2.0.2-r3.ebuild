# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils multilib-minimal

# This file cannot be mirrored.
# See the notes at http://tipok.org.ua/node/17
# The .tar.gz, ie the wrapper library, is lgpl though.
TGPPDIST=26410-800.zip

DESCRIPTION="HE-AAC+ v2 library, based on the reference implementation"
HOMEPAGE="http://tipok.org.ua/node/17"
SRC_URI="
	https://tipok.org.ua/downloads/media/aacplus/libaacplus/${P}.tar.gz
	https://dev.gentoo.org/~aballier/${P}.tar.gz
	http://www.3gpp.org/ftp/Specs/archive/26_series/26.410/${TGPPDIST}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE="fftw static-libs"
RESTRICT="bindist mirror"

RDEPEND="
	!media-sound/aacplusenc
	fftw? ( >=sci-libs/fftw-3.3.3-r2:3.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-clang-inline-redefinition.patch"
)

src_prepare() {
	default
	sed \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		-i configure.ac || die
	eautoreconf
	cp "${DISTDIR}/${TGPPDIST}" src/ || die
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_with fftw fftw3) \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	emake -j1
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
