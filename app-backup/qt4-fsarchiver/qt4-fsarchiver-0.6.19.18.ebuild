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
	# fix .desktop file
	# as of newer versions qt4/qt5-fsarchiver/starter mate-qt4-fsarchiver.desktop,kde-qt4-fsarchiver.desktop gnome-qt4-fsarchiver.desktop
	# * was added so SED will edit them all , TO DO add more  Additional Window Managers sed...
	# sed -i '/OnlyShowIn=KDE'  kde-qt4-fsarchiver.desktop ,  can add for LXQT, Razorqt etc. or the like. or edit a few in mate..
	# 
	#sed -i \
	#-e '/Encoding/d' starter/"*${PN}"*.desktop \

	sed -i \
		-e '/Encoding/d' starter/"gnome-qt4-fsarchiver.desktop \
	sed -i \
		-e '/Encoding/d' starter/"kde-qt4-fsarchiver.desktop \
		|| die "sed on qt4-fsarchiver.desktop failed"
	sed -i \
		-e '/Encoding/d' starter/"mate-qt4-fsarchiver.desktop \
		|| die "sed on qt4-fsarchiver.desktop failed"
	# fix icon installation location
	sed -i \
		-e "/icon.path/s:app-install/icons:${PN}:" "*${PN}.pro" \
		|| die "sed on *${PN}.pro failed"
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
