# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator mozextension multilib

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="http://eid-mw.googlecode.com/svn/trunk/"
	inherit subversion autotools
	SRC_URI=""
else
	MY_P="${PN}-${PV/_p/-}"
	SRC_URI="http://eid.belgium.be/en/binaries/${MY_P}.tar_tcm406-250016.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/eid-mw-$(get_version_component_range 1-3)"
fi

SLOT="0"
LICENSE="LGPL-3"
DESCRIPTION="Belgian Electronic Identity Card middleware supplied by the Belgian Federal Government"

HOMEPAGE="http://eid.belgium.be"

IUSE="+gtk +xpi"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	>=sys-apps/pcsc-lite-1.2.9
	xpi? ( || ( >=www-client/firefox-bin-3.6.24
		>=www-client/firefox-3.6.20 ) )
	!app-misc/beid-runtime"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [[ ${PV} == "9999" ]]; then
	src_prepare() {
		eautoreconf
	}
else
	src_prepare() {
		epatch "${FILESDIR}"/fix-nodialog-bug.patch
	}
fi

src_configure() {
	econf $(use_enable gtk dialogs) --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	if use xpi; then
		declare MOZILLA_FIVE_HOME
		if has_version '>=www-client/firefox-3.6.20'; then
			MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
			xpi_install	"${D}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
		if has_version '>=www-client/firefox-bin-3.6.24'; then
			MOZILLA_FIVE_HOME="/opt/firefox"
			xpi_install	"${D}/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/belgiumeid@eid.belgium.be"
		fi
	fi
	rm -r "${D}/usr/share" "${D}"/usr/lib*/*.la
}
