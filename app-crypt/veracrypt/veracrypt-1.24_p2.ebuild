# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info pax-utils toolchain-funcs wxwidgets

DESCRIPTION="Disk encryption with strong security based on TrueCrypt"
HOMEPAGE="https://www.veracrypt.fr/en/Home.html"
SRC_URI="https://github.com/${PN}/VeraCrypt/archive/VeraCrypt_1.24-Update2.tar.gz -> ${P}.tar.gz"

# The modules not linked against in Linux include (but not limited to):
#   libzip, chacha-xmm, chacha256, chachaRng, rdrand, t1ha2
# Tested by actually removing the source files and performing a build
# For this reason, we don't have to worry about their licenses
LICENSE="Apache-2.0 BSD truecrypt-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+asm cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 cpu_flags_x86_ssse3 doc X"
RESTRICT="bindist mirror"

WX_GTK_VER="3.0-gtk3"

RDEPEND="
	sys-fs/lvm2
	sys-fs/fuse:0
	x11-libs/wxGTK:${WX_GTK_VER}[X?]
	app-admin/sudo
	dev-libs/pkcs11-helper
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	asm? ( dev-lang/yasm )
"

S="${WORKDIR}/VeraCrypt-VeraCrypt_1.24-Update2/src"

pkg_setup() {
	local CONFIG_CHECK="~BLK_DEV_DM ~CRYPTO ~CRYPTO_XTS ~DM_CRYPT ~FUSE_FS"
	linux-info_pkg_setup

	setup-wxwidgets
}

src_prepare() {
	# 1.24_p2 breaks the compilation against wxGTK[-X]
	# See: https://github.com/veracrypt/VeraCrypt/issues/531
	eapply -p2 "${FILESDIR}"/${PN}-1.24_p2-revert-wxwidgets-breakage.patch
	eapply -p2 "${FILESDIR}"/${PN}-1.24-no-gui-fix.patch
	default
}

src_compile() {
	local TC_EXTRA_CFLAGS="${CFLAGS}"
	local TC_EXTRA_CXXFLAGS="${CXXFLAGS}"
	local myemakeargs=(
		NOSTRIP=1
		NOTEST=1
		VERBOSE=1
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		TC_EXTRA_LFLAGS="${LDFLAGS}"
		WX_CONFIG="${WX_CONFIG}"
		$(usex X "" "NOGUI=1")
		$(usex asm "" "NOASM=1")
		$(usex cpu_flags_x86_sse2 "" "NOSSE2=1")
		$(usex cpu_flags_x86_sse4_1 "SSE41=1" "")
		$(usex cpu_flags_x86_ssse3 "SSSE3=1" "")
	)

	# We need to explicitly disable the GUI support when linking against
	# wxwidgets, in case it was compiled with USE=X
	if ! use X; then
		TC_EXTRA_CFLAGS="${TC_EXTRA_CFLAGS} -DwxUSE_GUI=0"
		TC_EXTRA_CXXFLAGS="${TC_EXTRA_CXXFLAGS} -DwxUSE_GUI=0"
	fi

	myemakeargs+=(
		TC_EXTRA_CFLAGS="${TC_EXTRA_CFLAGS}"
		TC_EXTRA_CXXFLAGS="${TC_EXTRA_CXXFLAGS}"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	"${S}/Main/veracrypt" --text --test || die "tests failed"
}

src_install() {
	local DOCS=( Readme.txt )
	local HTML_DOCS=( )

	dobin Main/veracrypt
	if use doc; then
		DOCS+=( "${S}"/../doc/EFI-DCS )
		docompress -x "/usr/share/doc/${PF}/EFI-DCS"
		HTML_DOCS+=( "${S}"/../doc/html/. )
	fi
	einstalldocs

	newinitd "${FILESDIR}/${PN}.init" ${PN}

	if use X; then
		local s
		for s in 16 48 128 256; do
			newicon -s ${s} Resources/Icons/VeraCrypt-${s}x${s}.xpm veracrypt.xpm
		done
		make_desktop_entry ${PN} "VeraCrypt" ${PN} "Utility;Security"
	fi

	pax-mark -m "${D%/}/usr/bin/veracrypt"
}

pkg_postinst() {
	ewarn "VeraCrypt has a very restrictive license. Please be explicitly aware"
	ewarn "of the limitations on redistribution of binaries or modified source."
}
