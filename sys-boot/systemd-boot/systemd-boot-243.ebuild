# Copyright 2016-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson toolchain-funcs

DESCRIPTION="UEFI boot manager from systemd (formerly gummiboot)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/"
SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	>=dev-util/intltool-0.50
	dev-util/gperf
	>=dev-util/patchelf-0.10
	virtual/pkgconfig
"
COMMON_DEPEND="
	>=sys-apps/util-linux-2.30
"
DEPEND="${COMMON_DEPEND}
	>=sys-boot/gnu-efi-3.0.2
	sys-libs/libcap
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd
"

S="${WORKDIR}/systemd-${PV}"

PATCHES=(
	"${FILESDIR}/237-libshared-static.patch"
)

src_configure() {
	local emesonargs=(
		-Dblkid=true
		-Defi=true
		-Dgnu-efi=true
		-Defi-cc="$(tc-getCC)"
		-Defi-ld="$(tc-getLD)"
		-Dsplit-usr=true
		-Drootprefix="${EPREFIX:-/}"

		-Dacl=false
		-Dapparmor=false
		-Daudit=false
		-Dbzip2=false
		-Delfutils=false
		-Dgcrypt=false
		-Dgnutls=false
		-Dkmod=false
		-Dlibcryptsetup=false
		-Dlibcurl=false
		-Dlibidn=false
		-Dlibidn2=false
		-Dlibiptc=false
		-Dlz4=false
		-Dmicrohttpd=false
		-Dpam=false
		-Dqrencode=false
		-Dseccomp=false
		-Dselinux=false
		-Dxkbcommon=false
		-Dxz=false
	)
	meson_src_configure
}

set_efi_arch() {
	case "$(tc-arch)" in
		amd64) efi_arch=x64 ;;
		arm)   efi_arch=arm ;;
		arm64) efi_arch=aa64 ;;
		x86)   efi_arch=x86 ;;
	esac
}

src_compile() {
	local efi_arch
	set_efi_arch
	local targets=(
		bootctl
		man/bootctl.1
		man/kernel-install.8
		src/boot/efi/linux${efi_arch}.efi.stub
		src/boot/efi/systemd-boot${efi_arch}.efi
	)
	cd "${BUILD_DIR}" || die
	eninja "${targets[@]}"
	patchelf --remove-rpath bootctl || die
}

src_install() {
	local efi_arch
	set_efi_arch
	dobin "${BUILD_DIR}"/bootctl src/kernel-install/kernel-install
	doman "${BUILD_DIR}"/man/{bootctl.1,kernel-install.8}
	exeinto usr/lib/kernel/install.d
	doexe src/kernel-install/{50-depmod,90-loaderentry}.install
	insinto usr/lib/systemd/boot/efi
	doins "${BUILD_DIR}"/src/boot/efi/{linux${efi_arch}.efi.stub,systemd-boot${efi_arch}.efi}
	einstalldocs
}
