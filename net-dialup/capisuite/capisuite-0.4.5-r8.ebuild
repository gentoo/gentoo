# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/capisuite/capisuite-0.4.5-r8.ebuild,v 1.3 2013/05/05 12:09:37 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=none # bugs 468292 and 468380
PYTHON_COMPAT=( python2_7 )
inherit autotools-utils flag-o-matic python-single-r1

DESCRIPTION="ISDN telecommunication suite providing fax and voice services"
HOMEPAGE="http://www.capisuite.org"
SRC_URI="http://www.capisuite.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="${PYTHON_DEPS}
	media-sound/sox
	>=media-libs/tiff-3.7.1
	media-gfx/jpeg2ps
	media-gfx/sfftobmp
	app-text/ghostscript-gpl
	net-dialup/capi4k-utils"
RDEPEND="${DEPEND}
	virtual/mta"

DOCS=( AUTHORS ChangeLog NEWS README TODO )
PATCHES=(
	"${FILESDIR}/${P}-as-needed.patch"
	# taken from capisuite-0.4.5-5.src.rpm (SuSE-9.3)
	"${FILESDIR}/${P}-capi4linux_v3.diff"
	# patched scripts/cs_helpers.pyin (bug #96540)
	"${FILESDIR}/${P}-date-header.patch"
	# patched src/backend/connection.cpp (bug #69522)
	"${FILESDIR}/${PN}-fax-compatibility.patch"
	# patched scripts/{incoming,idle}.py (bug #147854)
	"${FILESDIR}/${P}-syntax.patch"
	# GCC 4.3 patches (bug #236777)
	"${FILESDIR}/${P}-gcc43.patch"
	# Python 2.5 patches (bug #232734)
	"${FILESDIR}/${P}-python25.patch"
	# Compability with current SOX (bug #250320)
	"${FILESDIR}/${P}-sox.patch"
	# Compatibility with automake >= 1.11.2 (bug #424892)
	"${FILESDIR}/${P}-automake-1.11.patch"
	# Respect AR (bug #467222)
	"${FILESDIR}/${P}-respect-ar.patch"
)

src_configure() {
	strip-flags  # see bug #90901

	local myeconfargs=(
		--localstatedir="/var"
		--with-docdir="/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	rm -f "${D}"/usr/{lib,share}/capisuite/README
	rmdir -p --ignore-fail-on-non-empty "${D}/var/log"
	rm -f "${D}/usr/share/doc/${PF}"/{COPYING,manual.pdf}
	keepdir /var/spool/capisuite/{done,failed,sendq,users}

	newinitd "${FILESDIR}/capisuite.initd" capisuite

	insinto /etc/logrotate.d
	newins "${FILESDIR}/capisuite.logrotated" capisuite

	exeinto /etc/cron.daily
	doexe capisuite.cron

	insinto /etc/capisuite
	doins cronjob.conf
}
