# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="build a self-extracting and self-installing binary package"
HOMEPAGE="https://sourceforge.net/projects/pdv"
SRC_URI="mirror://sourceforge/pdv/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~x86-linux ~ppc-macos"
IUSE="X"

DEPEND="
	X? (
		>=x11-libs/motif-2.3:0
		>=x11-libs/libX11-1.0.0
		>=x11-libs/libXt-1.0.0
		>=x11-libs/libXext-1.0.0 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# fix a size-of-variable bug
	eapply "${FILESDIR}"/${P}-opt.patch
	# fix a free-before-use bug
	eapply "${FILESDIR}"/${P}-early-free.patch
	# fix a configure script bug
	eapply "${FILESDIR}"/${P}-x-config.patch
	# fix default args bug from assuming 'char' is signed
	eapply "${FILESDIR}"/${P}-default-args.patch
	# prevent pre-stripped binaries
	eapply "${FILESDIR}"/${P}-no-strip.patch

	# re-build configure script since patch was applied to configure.in
	cd "${S}"/X11
	mv configure.in configure.ac || die
	eautoreconf
	tc-export CC
}

src_configure() {
	local myconf=""
	use X || myconf="--without-x" # configure script is broken, cant use use_with
	econf ${myconf}
}

src_install() {
	dobin pdv pdvmkpkg
	doman pdv.1 pdvmkpkg.1
	if use X ; then
		dobin X11/xmpdvmkpkg
		doman xmpdvmkpkg.1
	fi
	dodoc AUTHORS ChangeLog NEWS README pdv.lsm
}
