# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Daemon to proxy GSSAPI context establishment and channel handling"
HOMEPAGE="https://github.com/gssapi/gssproxy"
SRC_URI="https://github.com/gssapi/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="debug selinux systemd"

COMMON_DEPEND=">=dev-libs/libverto-0.2.2
	>=dev-libs/ding-libs-0.6.1
	virtual/krb5
	selinux? ( sys-libs/libselinux )"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-gssproxy )"
# We need xml stuff to build the man pages, and people really want/need
# the man pages for this package :). #585200
BDEPEND="
	app-text/docbook-xml-dtd:4.4
	dev-libs/libxslt
	virtual/pkgconfig
"

# Many requirements to run tests, including running slapd as root, hence
# unfeasible.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-fix-musl-llvm16-build.patch
)

# pkg_setup() {
#	# Here instead of flag-logic in DEPEND, since virtual/krb5 does not
#	# allow to specify the openldap use flag, which heimdal doesn't
#	# support.
#	# Using mit-krb5 explicitly because heimdal doesn't install kerberos
#	# schemata required for the tests of gss-proxy.
#	if use test && ! has_version "app-crypt/mit-krb5[openldap]"; then
#		eerror "Tests of this package require the kerberos schemata installed from app-crypt/mit-krb5[openldap]."
#		die "Tests enabled but no app-crypt/mit-krb5[openldap] being installed."
#	fi
# }

# Was required in 0.7.0 to fix the schema- and slapd-path. Reason for
# comment: see RESTRICT comment
# src_prepare() {
#	default
#	# The tests look for kerberos schemata in the documentation
#	# directory of krb5, however these are installed in /etc/openldap
#	# and only if the openldap useflag is supplied
#	sed -i \
#		-e 's#/usr/share/doc/krb5-server-ldap*#/etc/openldap/schema#' \
#		-e "s#\(subprocess.Popen..\"\)slapd#\1/usr/$(get_libdir)/openldap/slapd#" \
#		"${S}/tests/testlib.py" || die
# }

src_configure() {
	local myeconfargs=(
		# The build assumes localstatedir is /var and takes care of
		# using all the right subdirs itself.
		--localstatedir="${EPREFIX}"/var

		--with-os=gentoo
		--with-initscript=$(usex systemd systemd none)
		$(use_with selinux)
		$(use_with debug gssidebug)

		# We already set FORTIFY_SOURCE by default along with the
		# other bits. But setting it on each compile line interferes
		# with efforts to try e.g. FORTIFY_SOURCE=3. So, disable it,
		# but there's no actual difference to the safety of the binaries
		# because of Gentoo's configuration/patches to the toolchain.
		--without-hardening
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# This is a plugin module, so no need for la file.
	find "${ED}"/usr -name proxymech.la -delete || die

	doinitd "${FILESDIR}"/gssproxy
	insinto /etc/gssproxy
	doins examples/*.conf

	keepdir /var/lib/gssproxy
	keepdir /var/lib/gssproxy/clients
	keepdir /var/lib/gssproxy/rcache
	fperms 0700 /var/lib/gssproxy/clients
	fperms 0700 /var/lib/gssproxy/rcache

	# The build installs a bunch of empty dirs, so prune them.
	find "${ED}" -depth -type d -empty -delete || die
}
