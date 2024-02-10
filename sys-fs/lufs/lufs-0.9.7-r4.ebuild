# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="User-mode filesystem implementation"
HOMEPAGE="https://sourceforge.net/projects/lufs/"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="debug"

RDEPEND="sys-fs/lufis"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fPIC.patch
	"${FILESDIR}"/${PN}-automount-port.diff
	"${FILESDIR}"/${P}-enable-gnome-2.patch
	"${FILESDIR}"/${PN}-no-kernel.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

pkg_setup() {
	filesystems="ftpfs localfs"
	use amd64 || filesystems+=" sshfs"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	unset ARCH
	econf $(use_enable debug)
}

src_compile() {
	einfo "Compiling for ${filesystems}"

	cd filesystems || die
	local i
	for i in ${filesystems} ; do
		pushd ${i} &>/dev/null || die
		emake
		popd &>/dev/null || die
	done
}

src_install() {
	cd filesystems || die
	local i
	for i in ${filesystems} ; do
		pushd ${i} &>/dev/null || die
		emake DESTDIR="${D}" install
		popd &>/dev/null || die
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
