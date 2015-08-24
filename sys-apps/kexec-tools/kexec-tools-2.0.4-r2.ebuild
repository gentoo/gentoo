# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils flag-o-matic linux-info systemd

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="https://kernel.org/pub/linux/utils/kernel/kexec/"
SRC_URI="mirror://kernel/linux/utils/kernel/kexec/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="booke lzma xen zlib"

REQUIRED_USE="lzma? ( zlib )"

DEPEND="
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KEXEC"

PATCHES=(
		"${FILESDIR}"/${PN}-2.0.0-respect-LDFLAGS.patch
		"${FILESDIR}"/${P}-disable-kexec-test.patch
		"${FILESDIR}"/${P}-out-of-source.patch
	)

pkg_setup() {
	# GNU Make's $(COMPILE.S) passes ASFLAGS to $(CCAS), CCAS=$(CC)
	export ASFLAGS="${CCASFLAGS}"
	# to disable the -fPIE -pie in the hardened compiler
	if gcc-specs-pie ; then
		filter-flags -fPIE
		append-ldflags -nopie
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with booke)
		$(use_with lzma)
		$(use_with xen)
		$(use_with zlib)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodoc "${FILESDIR}"/README.Gentoo

	newinitd "${FILESDIR}"/kexec.init-${PVR} kexec
	newconfd "${FILESDIR}"/kexec.conf-${PV} kexec

	insinto /etc
	doins "${FILESDIR}"/kexec.conf

	systemd_dounit "${FILESDIR}"/kexec.service
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		elog "For systemd support the new config file is"
		elog "   /etc/kexec.conf"
		elog "Please adopt it to your needs as there is no autoconfig anymore"
	fi
}
