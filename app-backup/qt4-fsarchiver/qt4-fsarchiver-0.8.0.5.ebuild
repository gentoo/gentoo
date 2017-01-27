# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$ Necrose99 Proxymaintier
EAPI=5

inherit qmake-utils versionator eutils

MY_P="${PN}-$(replace_version_separator 3 '-')"
MIN_PV="$(get_version_component_range 1-3)"

DESCRIPTION="Qt4 frontend for fsarchiver"
HOMEPAGE="http://qt4-fsarchiver.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/source/${MY_P}.tar.gz
https://github.com/necrose99/qt4-fsarchiver/raw/master/SRC-TARBALLS/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="app-arch/bzip2
	app-arch/xz-utils
	dev-libs/libgcrypt:=
	dev-libs/lzo
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	sys-apps/util-linux
	sys-fs/e2fsprogs
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	>=app-backup/fsarchiver-${MIN_PV}[lzma,lzo]"
DEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
#use our custom fixes , to replace with Epatch however this will do for testing. 
#and I am none to fond of sed partly due to it being quite obscure.
	rm ${PN}/qt4-fsarchiver.pro  # fix Icons path manually was a sed statment. 
	cp "${FILESDIR}"/qt4-fsarchiver.pro ${PN}/
	# fix Pro file
	rm  ${PN}/starter/gnome-qt4-fsarchiver.desktop 
	rm  ${PN}/starter/kde-qt4-fsarchiver.desktop 
	rm  ${PN}/starter/mate-qt4-fsarchiver.desktop
	# clean out the desktop files. 
	cp "${FILESDIR}"/gnome-qt4-fsarchiver.desktop ${PN}/starter/gnome-qt4-fsarchiver.desktop
	cp "${FILESDIR}"/kde-qt4-fsarchiver.desktop ${PN}/starter/kde-qt4-fsarchiver.desktop
	cp "${FILESDIR}"/mate-qt4-fsarchiver.desktop ${PN}/starter/mate-qt4-fsarchiver.desktop
	|| die "copy from Files dir (patches) failed"
}

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog "The following packages may be installed to privide optional features/file system support & or Samba NFS etc: for network"
	optfeature "btrfs-progs" sys-fs/btrfs-progs 
	optfeature "jfsutils" sys-fs/jfsutils"
	optfeature "ntfs3g" sys-fs/ntfs3g[ntfsprogs]"
	optfeature "reiser4progs"  sys-fs/reiser4progs"
	optfeature "reiserprogs" sys-fs/reiserfsprogs"
	optfeature "sshfs-fuse" sys-fs/sshfs-fuse"
	optfeature "sys-fs/xfsprogs"  sys-fs/xfsprogs"
}
