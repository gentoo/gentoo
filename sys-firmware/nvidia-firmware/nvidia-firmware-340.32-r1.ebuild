# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit python-any-r1 unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"

FIRMWARE_REV="a0b9f9be0efad90cc84b8b2eaf587c3d7d350ea9"

DESCRIPTION="Kernel and mesa firmware for nouveau (video accel and pgraph)"
HOMEPAGE="https://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run
	https://raw.githubusercontent.com/envytools/firmware/${FIRMWARE_REV}/extract_firmware.py
		-> nvidia_extract_firmware-${FIRMWARE_REV}.py"

LICENSE="MIT NVIDIA-r2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="bindist mirror"

BDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}"

src_unpack() {
	mkdir "${S}/${X86_NV_PACKAGE}" || die
	cd "${S}/${X86_NV_PACKAGE}" || die
	unpack_makeself "${X86_NV_PACKAGE}.run"
}

src_compile() {
	"${EPYTHON}" "${DISTDIR}/nvidia_extract_firmware-${FIRMWARE_REV}.py" \
		|| die "Extracting firmwares failed"
}

src_install() {
	insinto /lib/firmware/nouveau
	doins nv* vuc-*
}
