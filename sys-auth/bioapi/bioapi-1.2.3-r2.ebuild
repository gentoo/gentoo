# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/bioapi/bioapi-1.2.3-r2.ebuild,v 1.6 2012/05/24 05:03:44 vapier Exp $

EAPI="2"

inherit eutils multilib user

DESCRIPTION="Framework for biometric-based authentication"
HOMEPAGE="http://code.google.com/p/bioapi-linux/"
SRC_URI="http://bioapi-linux.googlecode.com/files/${PN}_${PV}.tar.gz"

LICENSE="bioapi"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/bioapi-linux

src_prepare() {
	epatch "${FILESDIR}"/${P}-enroll-ret.patch #236654
	epatch "${FILESDIR}"/${P}-no-delete.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-build.patch #336107
	rm -f config.{guess,sub} #337805
	touch config.{guess,sub}
}

src_configure() {
	econf --without-Qt-dir
}

src_install() {
	emake SKIPCONFIG=true DESTDIR="${D}" install || die
	dodoc README
	dohtml *.htm

	# rename generic binaries
	mv "${D}"/usr/bin/{,BioAPI}Sample || die
}

pkg_config() {
	mds_install -s /usr/$(get_libdir)
	mod_install -fi /usr/$(get_libdir)/libbioapi100.so
	mod_install -fi /usr/$(get_libdir)/libbioapi_dummy100.so
	mod_install -fi /usr/$(get_libdir)/libpwbsp.so
}

pkg_preinst() {
	if [[ -e ${ROOT}/var/bioapi ]] && [[ ! -e ${ROOT}/var/lib/bioapi ]] ; then
		einfo "Moving /var/bioapi to /var/lib/bioapi"
		dodir /var/lib
		mv "${ROOT}"/var/bioapi "${ROOT}"/var/lib/bioapi
	fi
}

pkg_postinst() {
	einfo "Some generic-named programs have been renamed:"
	einfo "  Sample -> BioAPISample"

	if [[ ${ROOT} == "/" ]] ; then
		pkg_config
	else
		ewarn "You will need to run 'emerge --config bioapi' before"
		ewarn " you can use bioapi properly."
	fi

	# XXX: this can't be correct ...
	enewgroup bioapi
	chgrp bioapi "${ROOT}"/var/lib/bioapi -R
	chmod g+w,o= "${ROOT}"/var/lib/bioapi -R
	einfo "Note: users using bioapi must be in group bioapi."
}

pkg_prerm() {
	mod_install -fu libbioapi100.so
	mod_install -fu libbioapi_dummy100.so
	mod_install -fu libpwbsp.so
}
