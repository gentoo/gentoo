# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Necrose99 Proxymaintier  Exp $
EAPI=6

inherit ${SCM}  qmake-utils versionator

MY_P="${PN}-$(replace_version_separator 3 '-')"
MIN_PV="$(get_version_component_range 1-3)"

if [[ ${PV} == *9999 ]] ; then
	SCM="git-r3"
	EGIT_REPO_URI="git://github.com/DieterBaum/${PN}.git https://github.com/DieterBaum/${PN}.git"  
fi

DESCRIPTION="Qt5 frontend for fsarchiver forked into qt5 flavor"
HOMEPAGE="http://qt4-fsarchiver.sourceforge.net/"

MY_P=${P/_/-}
MY_PV=${PV/_/-}

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	# TODO!
	# git submodule packaging really is a mess
	SRC_URI="
		SRC_URI="https://github.com/DieterBaum/qt4-fsarchiver/${PN}/source/${PV}.tar.gz
		mirror://sourceforge/qt4-fsarchiver/${PN}/source/${MY_P}.tar.gz"
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		cd $EGIT_SOURCEDIR
		git submodule update --init --recursive
		S="EGIT_SOURCEDIR"
	else
	S="${WORKDIR}/${PN}"
	}

LICENSE="GPL-2"
SLOT="0"

#ssh-fs & cifs / samba are highly recomened for network backups and LIVE rescue type disk/s

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



src_prepare() {
	# fix .desktop file
	# as of newer versions qt4-fsarchiver/Qt5-Fsarchiver/starter mate-qt4-fsarchiver.desktop,kde-qt4-fsarchiver.desktop gnome-qt4-fsarchiver.desktop
	# * was added so SED will edit them all , TO DO add more  Additional Window Managers sed...
	# sed -i '/OnlyShowIn=KDE'  kde-qt4-fsarchiver.desktop ,  can add for LXQT, Razorqt etc. or the like. or edit a few in mate..
	# 
	
	sed -i \
		-e '/Encoding/d' starter/"*${PN}"*.desktop \
		|| die "sed on qt4-fsarchiver.desktop failed"
	# fix icon installation location
	sed -i \
		-e "/icon.path/s:app-install/icons:${PN}:" "*${PN}.pro" \
		|| die "sed on *${PN}.pro failed"
}

src_configure() {
	eqmake
}
src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  sys-fs/btrfs-progs"
	elog "  sys-fs/jfsutils"
	elog "  sys-fs/ntfs3g[ntfsprogs]"
	elog "  sys-fs/reiser4progs"
	elog "  sys-fs/reiserfsprogs"
	elog "  net-fs/sshfs"
	elog "  sys-fs/xfsprogs"
}
