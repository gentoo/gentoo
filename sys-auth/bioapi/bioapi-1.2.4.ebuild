# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib user

DESCRIPTION="Framework for biometric-based authentication"
HOMEPAGE="https://github.com/mr-c/bioapi-linux"
SRC_URI="https://bioapi-linux.googlecode.com/files/${PN}_${PV}.tar.gz"

LICENSE="bioapi"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

S=${WORKDIR}/bioapi-linux

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.3-no-delete.patch
	epatch "${FILESDIR}"/${PN}-1.2.4-build.patch #336107
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--without-Qt-dir
}

src_install() {
	SKIPCONFIG=true default
	use static-libs || find "${ED}" -name '*.la' -delete
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
	if [[ -e ${EROOT}/var/bioapi ]] && [[ ! -e ${EROOT}/var/lib/bioapi ]] ; then
		einfo "Moving /var/bioapi to /var/lib/bioapi"
		dodir /var/lib
		mv "${ROOT}"/var/bioapi "${ROOT}"/var/lib/bioapi
	fi
}

pkg_postinst() {
	einfo "Some generic-named programs have been renamed:"
	einfo "  Sample -> BioAPISample"

	if [[ ${EROOT} == "/" ]] ; then
		pkg_config
	else
		ewarn "You will need to run 'emerge --config bioapi' before"
		ewarn " you can use bioapi properly."
	fi

	# XXX: this can't be correct ...
	enewgroup bioapi
	chgrp bioapi "${EROOT}"/var/lib/bioapi -R
	chmod g+w,o= "${EROOT}"/var/lib/bioapi -R
	einfo "Note: users using bioapi must be in group bioapi."
}

pkg_prerm() {
	mod_install -fu libbioapi100.so
	mod_install -fu libbioapi_dummy100.so
	mod_install -fu libpwbsp.so
}
