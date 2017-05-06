# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 readme.gentoo-r1

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="http://www.tianocore.org/edk2 https://github.com/tianocore/edk2"

# inherit git-r3
# EGIT_REPO_URI="https://github.com/tianocore/edk2"
# EGIT_BRANCH="UDK2017"
# EGIT_COMMIT="f30c40618b1f3537705b450a91ce00b9e587badb"

SRC_URI="
	binary? ( https://dev.gentoo.org/~tamiko/distfiles/${P}-bin.tar.xz )
	!binary? ( https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.xz )"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="+binary"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	!amd64? ( binary )"

DEPEND="
	!binary? (
		amd64? (
			>=dev-lang/nasm-2.0.7
			>=sys-power/iasl-20160729
			${PYTHON_DEPS}
		)
	)"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-build_system_fixes.patch
)

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="This package contains the tianocore edk2 UEFI firmware for 64-bit x86
virtual machines. The firmware is located under
	/usr/share/edk2-ovmf/OVMF.fd
	/usr/share/edk2-ovmf/OVMF_CODE.fd
	/usr/share/edk2-ovmf/OVMF_VARS.fd

The firmware does not support csm (due to no free csm implementation
available). If you need a firmware with csm support you have to download
one for yourself. Firmware blobs are commonly labeled
	OVMF{,_CODE,_VARS}-with-csm.fd

In order to use the firmware you can run qemu the following way

	$ qemu-system-x86_64 \
		-drive file=/usr/share/edk2-ovmf/OVMF.fd,if=pflash,format=raw,unit=0,readonly=on \
		...

You can register the firmware for use in libvirt by adding to /etc/libvirt/qemu.conf:
	nvram = [
		\"/usr/share/edk2-ovmf/OVMF_CODE.fd:/usr/share/edk2-ovmf/OVMF_VARS.fd\"
	]"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
}

src_prepare() {
	if use binary; then
		eapply_user
		return
	fi
	default
}

src_compile() {
	TARGET_ARCH=X64
	TARGET_NAME=RELEASE
	TARGET_TOOLS=GCC49

	use binary && return

	emake ARCH=${TARGET_ARCH} -C BaseTools -j1

	. ./edksetup.sh

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		-D FD_SIZE_2MB \
		|| die "OvmfPkg/build.sh failed"
}

src_install() {
	local builddir="Build/OvmfX64/${TARGET_NAME}_${TARGET_TOOLS}/FV"

	insinto /usr/share/${PN}
	doins "${builddir}"/OVMF{,_CODE,_VARS}.fd

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
