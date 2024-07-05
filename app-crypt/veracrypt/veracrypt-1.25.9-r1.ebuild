# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note too treecleaners: This is the last veracrypt version that
# supports mounting truecrypt volumes. Let's give folks more time than
# usual to figure out what to do with their existing truecrypt volumes.
# Please do not treeclean before February 2024 unless it's necessary.

WX_GTK_VER="3.2-gtk3"
inherit desktop flag-o-matic linux-info pax-utils toolchain-funcs wxwidgets xdg

DESCRIPTION="Disk encryption with strong security based on TrueCrypt"
HOMEPAGE="https://www.veracrypt.fr/en/Home.html"
SRC_URI="https://github.com/${PN}/VeraCrypt/archive/VeraCrypt_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/VeraCrypt-VeraCrypt_${PV}/src"

# The modules not linked against in Linux include (but not limited to):
#   libzip, chacha-xmm, chacha256, chachaRng, rdrand, t1ha2
# Tested by actually removing the source files and performing a build
# For this reason, we don't have to worry about their licenses
LICENSE="Apache-2.0 BSD truecrypt-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+asm cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 cpu_flags_x86_ssse3 doc X"
RESTRICT="bindist mirror"

RDEPEND="
	sys-fs/lvm2
	sys-fs/fuse:0
	x11-libs/wxGTK:${WX_GTK_VER}[X?]
	app-admin/sudo
	dev-libs/pkcs11-helper"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	asm? ( dev-lang/yasm )"

CONFIG_CHECK="~BLK_DEV_DM ~CRYPTO ~CRYPTO_XTS ~DM_CRYPT ~FUSE_FS"

PATCHES=( "${FILESDIR}/${P}-wxGTK3.2.patch" )
src_configure() {
	setup-wxwidgets

	# https://bugs.gentoo.org/786741
	# std::byte clashes with src/Common/Tcdefs.h typedef
	append-cxxflags -std=c++14
}

src_compile() {
	local myemakeargs=(
		NOSTRIP=1
		NOTEST=1
		VERBOSE=1
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		TC_EXTRA_CFLAGS="${CFLAGS}"
		TC_EXTRA_CXXFLAGS="${CXXFLAGS}"
		TC_EXTRA_LFLAGS="${LDFLAGS}"
		WX_CONFIG="${WX_CONFIG}"
		$(usex X "" "NOGUI=1")
		$(usex asm "" "NOASM=1")
		$(usex cpu_flags_x86_sse2 "" "NOSSE2=1")
		$(usex cpu_flags_x86_sse4_1 "SSE41=1" "")
		$(usex cpu_flags_x86_ssse3 "SSSE3=1" "")
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	./Main/veracrypt --text --test || die "tests failed"
}

src_install() {
	local DOCS=( Readme.txt )

	dobin Main/veracrypt
	if use doc; then
		DOCS+=( "${S}"/../doc/EFI-DCS )
		docompress -x /usr/share/doc/${PF}/EFI-DCS
		HTML_DOCS=( "${S}"/../doc/html/. )
	fi
	einstalldocs

	newinitd "${FILESDIR}"/veracrypt.init veracrypt

	if use X; then
		local s
		for s in 16 48 128 256; do
			newicon -s ${s} Resources/Icons/VeraCrypt-${s}x${s}.xpm veracrypt.xpm
		done
		make_desktop_entry veracrypt "VeraCrypt" veracrypt "Utility;Security"
	fi

	pax-mark -m "${ED}"/usr/bin/veracrypt
}

pkg_postinst() {
	xdg_pkg_postinst
	ewarn "VeraCrypt has a very restrictive license. Please be explicitly aware"
	ewarn "of the limitations on redistribution of binaries or modified source."
}
