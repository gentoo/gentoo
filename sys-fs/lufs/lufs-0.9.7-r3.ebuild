# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION="User-mode filesystem implementation"
HOMEPAGE="http://sourceforge.net/projects/lufs/"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE="debug"

RDEPEND="sys-fs/lufis"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-fPIC.patch
	epatch "${FILESDIR}"/lufs-automount-port.diff
	epatch "${FILESDIR}"/${P}-enable-gnome-2.patch
	epatch "${FILESDIR}"/lufs-no-kernel.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch

	filesystems="ftpfs localfs"
	use amd64 || filesystems+=" sshfs"

	eautoreconf
}

src_compile() {
	einfo "Compiling for ${filesystems}"
	unset ARCH
	econf $(use_enable debug) || die

	cd filesystems
	local i
	for i in ${filesystems} ; do
		cd ${i}
		emake || die "emake ${i} failed"
		cd ..
	done
}

src_install() {
	cd filesystems
	local i
	for i in ${filesystems} ; do
		cd ${i}
		emake DESTDIR="${D}" install || die "emake install ${i} failed"
		cd ..
	done
}

pkg_postinst() {
	ewarn "Lufs Kernel support and lufsd,lufsmnt have been disabled in favour"
	ewarn "of lufis, please use lufis to mount lufs-filesystems, eg:"
	if use amd64; then
		elog "# lufis fs=ftpfs,host=ftp.kernel.org /mnt/lufis/ -s"
	else
		elog "# lufis fs=sshfs,host=dev.gentoo.org,username=genstef /mnt/lufis/ -s"
	fi
	ewarn "If something does not work for you with this setup please"
	ewarn "complain to bugs.gentoo.org"
	einfo "Note: There is also the native sshfs implementation now"
	use amd64 && ewarn "lufs-sshfs does not work on amd64 and is disabled there."
}
