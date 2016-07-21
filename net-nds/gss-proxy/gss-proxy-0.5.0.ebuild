# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_P="${PN/-}-${PV}"

DESCRIPTION="daemon to proxy GSSAPI context establishment and channel handling"
HOMEPAGE="https://fedorahosted.org/gss-proxy/"
SRC_URI="https://fedorahosted.org/released/gss-proxy/${MY_P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug selinux systemd"

RDEPEND=">=dev-libs/libverto-0.2.2
	>=dev-libs/ding-libs-0.5.0
	virtual/krb5
	selinux? ( sys-libs/libselinux )"
# We need xml stuff to build the man pages, and people really want/need
# the man pages for this package :). #585200
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.4
	dev-libs/libxslt
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# The build assumes localstatedir is /var and takes care of
	# using all the right subdirs itself.
	econf \
		--localstatedir="${EPREFIX}/var" \
		--with-os=gentoo \
		--with-initscript=$(usex systemd systemd sysv) \
		$(use_with selinux) \
		$(use_with debug gssidebug)
}

src_install() {
	default
	# This is a plugin module, so no need for la file.
	find "${ED}"/usr -name proxymech.la -delete

	doinitd "${FILESDIR}"/gssproxy
	insinto /etc/gssproxy
	doins examples/*.conf
	insinto /etc/gss/mech.d
	newins examples/mech gssproxy.conf

	# The build installs a bunch of empty dirs, so prune them.
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null
}
