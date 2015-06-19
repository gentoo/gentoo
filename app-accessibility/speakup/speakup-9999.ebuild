# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speakup/speakup-9999.ebuild,v 1.10 2014/08/06 06:24:38 patrick Exp $

EAPI="2"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="http://linux-speakup.org/speakup.git"
	vcs=git-2
else
	SRC_URI="ftp://linux-speakup.org/pub/speakup/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit $vcs linux-mod

DESCRIPTION="The speakup linux kernel based screen reader"
HOMEPAGE="http://linux-speakup.org"

LICENSE="GPL-2"
SLOT="0"
IUSE="modules"

MODULE_NAMES="speakup(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_acntpc(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_acntsa(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_apollo(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_audptr(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_bns(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_decext(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_decpc(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_dectlk(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_dtlk(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_dummy(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_keypc(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_ltlk(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_soft(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_spkout(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)
	speakup_txprt(${PN}:\"${S}\"/modules:\"${S}\"/drivers/staging/speakup)"
BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
BUILD_TARGETS="clean all"

src_prepare() {
	use modules && cmd=die || cmd=ewarn
	if kernel_is lt 2 6 36; then
		$cmd "Speakup requires at least kernel version 2.6.36"
	fi
}

src_compile() {
	use modules && linux-mod_src_compile
}

src_install() {
	use modules && linux-mod_src_install
	dodoc Bugs.txt README To-Do
	dodoc drivers/staging/speakup/DefaultKeyAssignments
	dodoc drivers/staging/speakup/spkguide.txt
}

pkg_postinst() {
	use modules && linux-mod_pkg_postinst

	elog "You must set up the speech synthesizer driver to be loaded"
	elog "automatically in order for your system to start speaking"
	elog "when it is booted."
	if has_version "<sys-apps/baselayout-2"; then
		elog "this is done via /etc/modules.autoload.d/kernel-2.6"
	else
		elog "This is done via /etc/conf.d/modules."
	fi
}
