# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd eutils readme.gentoo-r1 user

DESCRIPTION="Minimalistic Murmur (Mumble server)"
HOMEPAGE="https://github.com/umurmur/umurmur"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gnutls libressl shm"

# ssl-provider precendence: gnutls, libressl
# and openssl if none specified
DEPEND=">=dev-libs/protobuf-c-1.0.0_rc2
	dev-libs/libconfig
	gnutls? ( >=net-libs/gnutls-3.0.0 )
	libressl? ( !gnutls? ( dev-libs/libressl ) )
	!gnutls? ( !libressl? ( dev-libs/openssl:0 ) )"

RDEPEND="${DEPEND}"

DOC_CONTENTS="
	A configuration file has been installed at /etc/umurmur/umurmur.conf - you
	may	want to review it. See also\n
	https://github.com/umurmur/umurmur/wiki/Configuration "

pkg_pretend() {
	local ssl_provider=(  )
	use gnutls && ssl_provider+=( gnutls )
	use libressl && ssl_provider+=( libressl )

	if [[ ${#ssl_provider[@]} -gt 1 ]] ; then
		ewarn "More than one ssl provider selected (${ssl_provider[@]})"
		ewarn "defaulting to ${ssl_provider[0]}."
	fi
}

pkg_setup() {
	enewgroup murmur
	enewuser murmur "" "" "" murmur
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf

	econf \
		--with-ssl=$(usev gnutls || echo openssl) \
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
}
