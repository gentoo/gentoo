# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	ESVN_REPO_URI="https://linux-wbfs-manager.googlecode.com/svn/trunk/"
	inherit subversion
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="https://linux-wbfs-manager.googlecode.com/files/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi;

DESCRIPTION="WBFS manager for Linux using GTK+"
HOMEPAGE="https://code.google.com/p/linux-wbfs-manager/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/libglade:2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

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
