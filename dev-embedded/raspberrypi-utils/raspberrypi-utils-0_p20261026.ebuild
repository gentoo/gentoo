# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..15} )
inherit cmake optfeature python-single-r1

COMMIT="b8961eb9a689a3c0465db108176d0ee425379730"

DESCRIPTION="Raspberry Pi userspace utilities"
HOMEPAGE="https://github.com/raspberrypi/utils"
SRC_URI="https://github.com/raspberrypi/utils/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/utils-${COMMIT}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	sys-apps/dtc
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	!media-libs/raspberrypi-userland
	!media-libs/raspberrypi-userland-bin
"

PATCHES=(
	"${FILESDIR}"/${PN}-silence-kms-missing-message.patch
	"${FILESDIR}"/${PN}-silence-sections-with-missing-commands.patch
	"${FILESDIR}"/${PN}-use-emerge-for-package-versions.patch
)

src_test() {
	# There are no upstream tests as this package is very hardware-focused, but
	# we can at least check that the Python utilities successfully run --help.
	find -type f -exec awk '/^#!.*python/ {print FILENAME} {nextfile}' {} + | xargs -ti "${PYTHON}" {} -h >/dev/null
}

src_install() {
	cmake_src_install
	python_fix_shebang "${ED}"/usr/bin
}

pkg_postinst() {
	optfeature "Sound status in raspinfo" media-sound/alsa-utils
	optfeature "USB status in raspinfo" sys-apps/usbutils
}
