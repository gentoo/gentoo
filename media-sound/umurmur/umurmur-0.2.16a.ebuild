# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/umurmur/umurmur-0.2.16a.ebuild,v 1.2 2015/06/21 13:21:36 ago Exp $

EAPI=5

inherit autotools systemd eutils readme.gentoo user

DESCRIPTION="Minimalistic Murmur (Mumble server)"
HOMEPAGE="http://code.google.com/p/umurmur/ https://github.com/umurmur/umurmur"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="gnutls polarssl shm"

DEPEND=">=dev-libs/protobuf-c-1.0.0_rc2
	dev-libs/libconfig
	gnutls? ( >=net-libs/gnutls-3.0.0 )
	polarssl? ( >=net-libs/polarssl-1.0.0 )
	!gnutls? ( !polarssl? ( dev-libs/openssl:0 ) )"

RDEPEND="${DEPEND}"

DOC_CONTENTS="
	A configuration file has been installed at /etc/umurmur.conf - you may
	want to review it. See also\n
	https://github.com/umurmur/umurmur/wiki/Configuration "

pkg_setup() {
	enewgroup murmur
	enewuser murmur "" "" "" murmur
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf

	if use polarssl && use gnutls; then
		ewarn "Both gnutls and polarssl requested, defaulting to polarssl."
	fi

	econf \
		--with-ssl=$(usev polarssl || usev gnutls || echo openssl) \
		$(use_enable shm shmapi)
}

src_install() {
	local confdir

	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/umurmurd.initd umurmurd
	newconfd "${FILESDIR}"/umurmurd.confd umurmurd
	systemd_dounit "${FILESDIR}"/umurmurd.service

	dodoc AUTHORS ChangeLog
	newdoc README.md README

	confdir="/etc/umurmur"
	insinto "${confdir}"
	doins "${FILESDIR}"/umurmur.conf

	# Some permissions are adjusted as the config may contain a server
	# password, and /etc/umurmur will typically contain the cert and the
	# key used to sign it, which are read after priveleges are dropped.
	fperms 0750 "${confdir}"
	fowners -R root:murmur "${confdir}"
	fperms 0640 "${confdir}"/umurmur.conf

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if use polarssl ; then
		elog
		elog "Because you have enabled PolarSSL support, umurmurd will use a"
		elog "predefined test-certificate and key if none are configured, which"
		elog "is insecure. See http://code.google.com/p/umurmur/wiki/Installing02x#Installing_uMurmur_with_PolarSSL_support"
		elog "for more information on how to create your certificate and key"
	fi
}
