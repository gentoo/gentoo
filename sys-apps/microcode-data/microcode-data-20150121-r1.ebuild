# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

NUM="24661"
DESCRIPTION="Intel IA32 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="http://downloadmirror.intel.com/${NUM}/eng/microcode-${PV}.tgz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="initramfs monolithic +split-ucode"
REQUIRED_USE="|| ( initramfs monolithic split-ucode )"

RDEPEND="!<sys-apps/microcode-ctl-1.17-r2" #268586

S=${WORKDIR}

src_unpack() {
	default
	cp "${FILESDIR}"/intel-microcode2ucode.c ./ || die
}

src_compile() {
	if use initramfs ; then
		iucode_tool --write-earlyfw=microcode.cpio microcode.dat || die
	fi

	if use split-ucode ; then
		tc-env_build emake intel-microcode2ucode
		./intel-microcode2ucode microcode.dat || die
	fi
}

src_install() {
	insinto /lib/firmware
	use initramfs && doins microcode.cpio
	use monolithic && doins microcode.dat
	use split-ucode && doins -r intel-ucode
}

pkg_postinst() {
	elog "The microcode available for Intel CPUs has been updated.  You'll need"
	elog "to reload the code into your processor.  If you're using the init.d:"
	elog "/etc/init.d/microcode_ctl restart"
}
