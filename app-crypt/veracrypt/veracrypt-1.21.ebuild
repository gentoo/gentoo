# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info pax-utils toolchain-funcs wxwidgets

DESCRIPTION="Disk encryption with strong security based on TrueCrypt"
HOMEPAGE="https://www.veracrypt.fr/en/Home.html"
SRC_URI="https://github.com/${PN}/VeraCrypt/archive/VeraCrypt_${PV}.tar.gz"

LICENSE="Apache-2.0 truecrypt-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+asm +doc X"
RESTRICT="bindist mirror"

WX_GTK_VER="3.0"

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

S="${WORKDIR}/VeraCrypt-VeraCrypt_${PV}/src"
HTML_DOCS=( "${S}"/../doc/html/. )
DOCS=( Readme.txt )

pkg_setup() {
	local CONFIG_CHECK="~BLK_DEV_DM ~CRYPTO ~CRYPTO_XTS ~DM_CRYPT ~FUSE_FS"
	linux-info_pkg_setup

	setup-wxwidgets
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
	)
	use X || myemakeargs+=( NOGUI=1 )
	use asm || myemakeargs+=( NOASM=1 )

	emake "${myemakeargs[@]}"
}

src_test() {
	"${S}/Main/veracrypt" --text --test || die "tests failed"
}

src_install() {
	dobin Main/veracrypt
	use doc && einstalldocs

	newinitd "${FILESDIR}/${PN}.init" ${PN}

	if use X; then
		local s
		for s in 16 48 128 256; do
			newicon -s ${s} Resources/Icons/VeraCrypt-${s}x${s}.xpm veracrypt.xpm
		done
		make_desktop_entry ${PN} "VeraCrypt" ${PN} "Encryption;Encryption Tools;Utility;"
	fi

	pax-mark -m "${D%/}/usr/bin/veracrypt"
}

pkg_postinst() {
	ewarn "VeraCrypt has a very restrictive license. Please be explicitly aware"
	ewarn "of the limitations on redistribution of binaries or modified source."
}
