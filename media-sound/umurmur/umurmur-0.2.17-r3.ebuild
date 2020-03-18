# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd readme.gentoo-r1

DESCRIPTION="Minimalistic Murmur (Mumble server)"
HOMEPAGE="https://github.com/umurmur/umurmur"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/umurmur/umurmur.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV/_}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm x86"
fi
LICENSE="BSD"
SLOT="0"
IUSE="gnutls libressl mbedtls shm"

# ssl-provider precendence: gnutls, mbedtls, libressl
# and openssl if none specified
DEPEND=">=dev-libs/protobuf-c-1.0.0_rc2
	dev-libs/libconfig
	gnutls? (
		dev-libs/nettle:=
		>=net-libs/gnutls-3.0.0
	)
	!gnutls? (
		mbedtls? ( net-libs/mbedtls:= )
		!mbedtls? (
			libressl? ( dev-libs/libressl:0= )
			!libressl? ( dev-libs/openssl:0= )
		)
	)
"

RDEPEND="${DEPEND}
	acct-group/murmur
	acct-user/murmur
"

DOC_CONTENTS="
	A configuration file has been installed at /etc/umurmur/umurmur.conf - you
	may	want to review it. See also\n
	https://github.com/umurmur/umurmur/wiki/Configuration "

S="${WORKDIR}/${P/_}"

get_ssl_impl() {
	local ssl_provider=()

	use gnutls && ssl_provider+=( gnutls )
	use mbedtls && ssl_provider+=( mbedtls )
	use libressl && ssl_provider+=( libressl )

	if ! use gnutls && ! use mbedtls && ! use libressl ; then
		ssl_provider+=( openssl )
	fi
	echo ${ssl_provider[@]}
}

pkg_pretend() {
	local ssl_provider=( $(get_ssl_impl) )

	if [[ ${#ssl_provider[@]} -gt 1 ]] ; then
		ewarn "More than one ssl provider selected (${ssl_provider[@]})"
		ewarn "defaulting to ${ssl_provider[0]}."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local ssl_provider=( $(sed 's@libressl@openssl@' <<< $(get_ssl_impl)) )

	local myeconfargs=(
		--with-ssl="${ssl_provider[@]}"
		$(use_enable shm shmapi)
	)
	econf "${myeconfargs[@]}"
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
