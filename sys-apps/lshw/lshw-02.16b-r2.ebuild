# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit flag-o-matic eutils toolchain-funcs

MAJ_PV=${PV:0:${#PV}-1}
MIN_PVE=${PV:0-1}
MIN_PV=${MIN_PVE/b/B}

MY_P="$PN-$MIN_PV.$MAJ_PV"
DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLiSter"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="gtk sqlite static"

REQUIRED_USE="static? ( !gtk )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	sqlite? ( virtual/pkgconfig )"
RDEPEND="${RDEPEND}
	sys-apps/hwids"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	# correct gettext behavior
	if [[ -n "${LINGUAS+x}" ]] ; then
		local langs

		for i in $(cd po ; echo *.po | sed 's/\.po//') ; do
			if has ${i} ${LINGUAS} ; then
				langs+=" ${i}"
			fi
		done
		sed -i \
			-e "/^LANGUAGES =/ s/=.*/= $langs/" \
			src/po/Makefile || die
	fi
}

src_compile() {
	tc-export CC CXX AR
	use static && append-ldflags -static

	local sqlite=$(usex sqlite 1 0)

	emake SQLITE=$sqlite all
	if use gtk ; then
		emake SQLITE=$sqlite gui
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README docs/*
	if use gtk ; then
		emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install-gui
		make_desktop_entry /usr/sbin/gtk-lshw "Hardware Lister" "/usr/share/lshw/artwork/logo.svg"
	fi
}
