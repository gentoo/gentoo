# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
if [[ "${PV}" == "9999" ]]; then
	ESVN_REPO_URI="https://linux-wbfs-manager.googlecode.com/svn/trunk/"
	inherit toolchain-funcs subversion
	SRC_URI=""
	#KEYWORDS=""
else
	inherit toolchain-funcs
	SRC_URI="https://linux-wbfs-manager.googlecode.com/files/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi;

DESCRIPTION="WBFS manager for Linux using GTK+"
HOMEPAGE="https://code.google.com/p/linux-wbfs-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/libglade:2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [[ ${PV} == "9999" ]] ; then
	S=${WORKDIR}/${ECVS_MODULE}
else
	S=${WORKDIR}/${PN}
fi

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		subversion_src_unpack
	else
		default
	fi
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin wbfs_gtk
	dodoc README
}
