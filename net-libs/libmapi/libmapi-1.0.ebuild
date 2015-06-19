# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmapi/libmapi-1.0.ebuild,v 1.2 2014/08/10 20:49:26 slyfox Exp $

EAPI="4"
PYTHON_DEPEND="python? *"

inherit autotools eutils python

MY_PN=openchange
MY_P=${MY_PN}-${PV}-BORG

DESCRIPTION="Portable open-source implementations of Exchange protocols"
HOMEPAGE="http://www.openchange.org/"
SRC_URI="http://tracker.openchange.org/attachments/download/180/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python"

RDEPEND=">=net-fs/samba-4.0.0_rc2
	dev-libs/boost
	python? ( dev-lang/python )"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/"${MY_P}"-python-location-fix.patch
	epatch "${FILESDIR}"/"${MY_P}"-fix-soname-QA.patch
	eaclocal
	eautoconf
}
src_configure() {
	ECONF="--disable-coverage
		$(use_enable python pymapi)"

	econf ${ECONF}
}

src_compile() {
	emake libmapi libmapixx || die "libmapi compilation failed"
}

src_install() {
	emake DESTDIR="${D}" libmapi-install libmapixx-install || die "libmapi install failed"

	if use python ; then
		emake DESTDIR="${D}" python-install || die "pymapi install failed"
	fi
}
