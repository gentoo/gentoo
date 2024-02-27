# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="build a self-extracting and self-installing binary package"
HOMEPAGE="https://sourceforge.net/projects/pdv/"
SRC_URI="mirror://sourceforge/pdv/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~x86-linux ~ppc-macos"
IUSE="gui"

RDEPEND="
	gui? (
		>=x11-libs/motif-2.3:0
		>=x11-libs/libX11-1.0.0
		>=x11-libs/libXt-1.0.0
		>=x11-libs/libXext-1.0.0
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	# fix a size-of-variable bug
	"${FILESDIR}"/${P}-opt.patch
	# fix a free-before-use bug
	"${FILESDIR}"/${P}-early-free.patch
	# fix a configure script bug
	"${FILESDIR}"/${P}-x-config.patch
	# fix default args bug from assuming 'char' is signed
	"${FILESDIR}"/${P}-default-args.patch
	# prevent pre-stripped binaries
	"${FILESDIR}"/${P}-no-strip.patch
	# missing function prototype, see bug #882157
	"${FILESDIR}"/${P}-missing-prototype.patch
)

src_prepare() {
	default

	# re-build configure script since patch was applied to configure.in
	# and to refresh old compiler checks, see bugs #880351 and #906002
	eautoreconf
}

src_configure() {
	tc-export CC

	econf $(usev !gui --without-x) # configure script is broken, cant use use_with
}

src_install() {
	dobin pdv pdvmkpkg
	doman pdv.1 pdvmkpkg.1
	if use gui ; then
		dobin X11/xmpdvmkpkg
		doman xmpdvmkpkg.1
	fi
	dodoc AUTHORS ChangeLog NEWS README pdv.lsm
}
