# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils rpm toolchain-funcs

KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="Chrome OS verified boot tools"
HOMEPAGE="http://git.chromium.org/gitweb/?p=chromiumos/platform/vboot_reference.git"
EGIT_COMMIT="e6cf2c21a1cd6fc46b6adcaadc865e2f8bd4874e"
MY_VERSION="${PV##*_p}git${EGIT_COMMIT:0:7}"
MY_PV="${PN}-${MY_VERSION}"
SRC_URI="http://kojipkgs.fedoraproject.org/packages/${PN}/${MY_VERSION}/3.fc19/src/${MY_PV}-3.fc19.src.rpm"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="app-arch/xz-utils:=
	dev-libs/libyaml:=
	dev-libs/openssl:0=
	sys-apps/util-linux:="

DEPEND="app-crypt/trousers
	${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	rpm_unpack ${A}
	unpack ./${MY_PV}.tar.xz
	mv ./${MY_PV}/* ./ || die
}

src_prepare() {
	epatch *.patch
	sed -e 's:-Werror ::g' -e 's:-nostdinc ::g' \
		-i Makefile || die
}

src_compile() {
	mkdir "${S}"/build-main || die
	tc-export CC AR CXX PKG_CONFIG
	emake \
		-j1 \
		V=1 \
		BUILD="${S}"/build-main \
		ARCH=$(tc-arch) \
		all
	unset CC AR CXX PKG_CONFIG
}

src_test() {
	# ARCH and HOST_ARCH must be identical in order
	# to avoid calling qemu.
	local arch=$(tc-arch)
	[[ ${arch} == amd64 ]] && arch=x86_64
	emake \
		V=1 \
		BUILD="${S}"/build-main \
		ARCH=${arch} \
		HOST_ARCH=${arch} \
		runtests
}

src_install() {
	emake \
		V=1 \
		BUILD="${S}"/build-main \
		DESTDIR="${ED}/usr/bin" \
		install
	insinto /usr/share/vboot/devkeys
	doins tests/devkeys/*
	dodoc README
}
