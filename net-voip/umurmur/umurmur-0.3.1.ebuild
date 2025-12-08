# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd readme.gentoo-r1

DESCRIPTION="Minimalistic Murmur (Mumble server)"
HOMEPAGE="https://github.com/umurmur/umurmur"
SRC_URI="https://github.com/umurmur/umurmur/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gnutls mbedtls shm"

# ssl-provider precendence: gnutls, mbedtls and openssl if none specified
DEPEND=">=dev-libs/protobuf-c-1.0.0:=
	dev-libs/libconfig:=
	gnutls? (
		dev-libs/nettle:=
		>=net-libs/gnutls-3.0.0:=
	)
	!gnutls? (
		mbedtls? ( net-libs/mbedtls:3= )
		!mbedtls? ( dev-libs/openssl:0= )
	)
"

RDEPEND="${DEPEND}
	acct-group/murmur
	acct-user/murmur
"

DOC_CONTENTS="
	A configuration file has been installed at /etc/umurmur/umurmur.conf - you
	may want to review it. See also\n
	https://github.com/umurmur/umurmur/wiki/Configuration "

PATCHES=(
	"${FILESDIR}/umurmur-0.3.1-mbedtls-3.patch"
)

get_ssl_impl() {
	local ssl_provider=()

	use gnutls && ssl_provider+=( gnutls )
	use mbedtls && ssl_provider+=( mbedtls )

	if ! use gnutls && ! use mbedtls ; then
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

src_configure() {
	local ssl_provider=( $(get_ssl_impl) )

	local mycmakeargs=(
		-DSSL="${ssl_provider[0]}"
		-DUSE_SHAREDMEMORY_API=$(usex shm)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/umurmurd.initd umurmurd
	newconfd "${FILESDIR}"/umurmurd.confd umurmurd
	systemd_dounit "${FILESDIR}"/umurmurd.service

	dodoc AUTHORS ChangeLog README.md

	# Some permissions are adjusted as the config may contain a server
	# password, and /etc/umurmur will typically contain the cert and the
	# key used to sign it, which are read after priveleges are dropped.
	fperms 0750 "/etc/umurmur"
	fowners -R root:murmur "/etc/umurmur"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
