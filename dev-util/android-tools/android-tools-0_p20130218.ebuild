# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

MY_VERSION="${PV##*_p}"
GIT_SHA1="e89e09dd2b9b42184973e3ade291186a2737bced"

DESCRIPTION="Android platform tools (adb and fastboot)"
HOMEPAGE="https://android.googlesource.com/platform/system/core.git/"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/android-tools_4.2.2+git${MY_VERSION}.orig.tar.xz
	https://launchpad.net/ubuntu/+archive/primary/+files/android-tools_4.2.2+git${MY_VERSION}-3ubuntu36.debian.tar.gz
	https://github.com/android/platform_system_core/commit/${GIT_SHA1}.patch -> ${PN}-${GIT_SHA1}.patch"

# The entire source code is Apache-2.0, except for fastboot which is BSD.
LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="sys-libs/zlib:=
	dev-libs/openssl:0="

DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	pushd core >/dev/null || die
	epatch "${DISTDIR}"/${PN}-${GIT_SHA1}.patch #500480
	popd >/dev/null
	epatch ../debian/patches/*.patch
	mv ../debian/makefiles/adb.mk core/adb/Makefile || die
	mv ../debian/makefiles/fastboot.mk core/fastboot/Makefile || die

	# Avoid libselinux dependency.
	sed -e 's: -lselinux::' -i core/fastboot/Makefile || die
	sed -e '/#include <selinux\/selinux.h>/d' \
		-e 's:#include <selinux/label.h>:struct selabel_handle;:' \
		-i extras/ext4_utils/make_ext4fs.h || die
	sed -e '62,63d;180,189d;231,234d;272,274d;564,579d' \
		-i extras/ext4_utils/make_ext4fs.c || die

	tc-export CC
}

src_compile() {
	emake -C core/adb adb
	emake -C core/fastboot fastboot
}

src_install() {
	dobin core/adb/adb core/fastboot/fastboot
}
