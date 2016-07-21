# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"
X86_NV_PACKAGE="NVIDIA-Linux-x86-${PV}"

EXTRACT_FIRMWARE_REV="845a51ab607df85fc0ed01f0b5b6d57850e37662"

DESCRIPTION="Kernel and mesa firmware for nouveau (video accel and pgraph)"
HOMEPAGE="https://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="${NV_URI}Linux-x86/${PV}/${X86_NV_PACKAGE}.run
	https://raw.github.com/imirkin/re-vp2/${EXTRACT_FIRMWARE_REV}/extract_firmware.py -> nvidia_extract_firmware-${PV}.py"

LICENSE="MIT NVIDIA-r2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="=dev-lang/python-2*"
RDEPEND=""

RESTRICT="bindist mirror"

S="${WORKDIR}"

src_unpack() {
	mkdir "${S}/${X86_NV_PACKAGE}"
	cd "${S}/${X86_NV_PACKAGE}"
	unpack_makeself "${X86_NV_PACKAGE}.run"
}

src_compile() {
	python2 "${DISTDIR}"/nvidia_extract_firmware-${PV}.py || die "Extracting firmwares failed..."
}

src_install() {
	insinto /lib/firmware/nouveau
	doins nv* vuc-*
}
