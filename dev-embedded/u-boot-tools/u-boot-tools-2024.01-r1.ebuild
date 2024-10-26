# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="u-boot-${PV/_/-}"
DESCRIPTION="utilities for working with Das U-Boot"
HOMEPAGE="https://www.denx.de/wiki/U-Boot/WebHome"
SRC_URI="
	https://ftp.denx.de/pub/u-boot/${MY_P}.tar.bz2
	https://github.com/u-boot/u-boot/commit/88b9b9c44c859bdd9bb227e2fdbc4cbf686c3343.patch
		-> u-boot-tools-2024.01-fix-invalid-escape-sequence.patch
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="envtools"

RDEPEND="
	dev-libs/openssl:=
	net-libs/gnutls:=
	sys-apps/util-linux:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	# https://github.com/u-boot/u-boot/pull/489
	"${DISTDIR}"/u-boot-tools-2024.01-fix-invalid-escape-sequence.patch
)

src_prepare() {
	default
	sed -i 's:\bpkg-config\b:${PKG_CONFIG}:g' \
		scripts/kconfig/{g,m,n,q}conf-cfg.sh \
		scripts/kconfig/Makefile \
		tools/Makefile || die
}

src_configure() {
	tc-export AR BUILD_CC CC PKG_CONFIG
	tc-export_build_env
}

src_compile() {
	# Unset a few KBUILD variables. Bug #540476
	unset KBUILD_OUTPUT KBUILD_SRC

	local myemakeargs=(
		V=1
		AR="${AR}"
		CC="${CC}"
		HOSTCC="${BUILD_CC}"
		HOSTCFLAGS="${BUILD_CFLAGS} ${BUILD_CPPFLAGS}"' $(HOSTCPPFLAGS)'
		HOSTLDFLAGS="${BUILD_LDFLAGS}"
	)

	emake "${myemakeargs[@]}" tools-only_defconfig

	emake "${myemakeargs[@]}" \
		NO_SDL=1 \
		HOSTSTRIP=: \
		STRIP=: \
		CONFIG_ENV_OVERWRITE=y \
		$(usex envtools envtools tools-all)
}

src_test() { :; }

src_install() {
	cd tools || die

	if ! use envtools; then
		dobin dumpimage fdtgrep gen_eth_addr img2srec mkeficapsule mkenvimage mkimage
	fi

	dobin env/fw_printenv

	dosym fw_printenv /usr/bin/fw_setenv

	insinto /etc
	doins env/fw_env.config

	doman ../doc/mkimage.1
}
