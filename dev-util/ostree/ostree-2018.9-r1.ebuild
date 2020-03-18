# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Operating system and container binary deployment and upgrades"
HOMEPAGE="https://ostree.readthedocs.io/en/latest/"
SRC_URI="https://github.com/ostreedev/ostree/releases/download/v${PV}/lib${P}.tar.xz -> ${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2+"
SLOT="0"

IUSE="archive curl doc dracut gnutls grub http2 httpd introspection libmount selinux ssl soup systemd zeroconf"
RESTRICT="test"
REQUIRED_USE="httpd? ( || ( curl soup ) )"

COMMON_DEPEND="
	archive? ( app-arch/libarchive )
	app-crypt/gpgme
	app-arch/xz-utils
	curl? ( net-misc/curl )
	soup? ( net-libs/libsoup )
	dev-libs/glib:2
	dev-libs/libassuan
	dev-libs/libgpg-error
	dracut? ( sys-kernel/dracut )
	grub? ( sys-boot/grub:2= )
	introspection? ( dev-libs/gobject-introspection )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl:0= ) )
	sys-fs/fuse:0
	sys-libs/zlib
	libmount? ( sys-apps/util-linux )
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd:0= )
	zeroconf? ( net-dns/avahi[dbus] )"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	doc? ( dev-util/gtk-doc )"

RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig"

S="${WORKDIR}/lib${P}"

src_prepare() {
	sed -Ee 's:(XSLT_STYLESHEET = ).*:\1/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl:' \
		-i Makefile.in Makefile-man.am || die

	# The ostree-finalize-staged.path file is missing in ostree-2018.9.tar.xz.
	[ -e src/boot/ostree-finalize-staged.path ] && die
	cat > src/boot/ostree-finalize-staged.path <<-EOF
		# Copyright (C) 2018 Red Hat, Inc.
		#
		# This library is free software; you can redistribute it and/or
		# modify it under the terms of the GNU Lesser General Public
		# License as published by the Free Software Foundation; either
		# version 2 of the License, or (at your option) any later version.
		#
		# This library is distributed in the hope that it will be useful,
		# but WITHOUT ANY WARRANTY; without even the implied warranty of
		# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
		# Lesser General Public License for more details.
		#
		# You should have received a copy of the GNU Lesser General Public
		# License along with this library; if not, write to the
		# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
		# Boston, MA 02111-1307, USA.

		# For some implementation discussion, see:
		# https://lists.freedesktop.org/archives/systemd-devel/2018-March/040557.html
		[Unit]
		Description=OSTree Monitor Staged Deployment
		Documentation=man:ostree(1)

		[Path]
		PathExists=/run/ostree/staged-deployment

		[Install]
		WantedBy=multi-user.target
	EOF

	eautoreconf
	default
}

src_configure() {
	local econfargs=(
		--enable-man
		--enable-shared
		$(use_with archive libarchive)
		$(use_with curl)
		$(use_with dracut)
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_enable http2)
		$(use_enable httpd trivial-httpd-cmdline)
		$(use_with selinux )
		$(use_with soup)
		$(use_with libmount)
		$(use ssl && { use gnutls && echo --with-crypto=gnutls || echo --with-crypto=openssl; })
		$(use_with systemd libsystemd)
		$(use_with zeroconf avahi)
	)

	unset ${!XDG_*} #657346 g-ir-scanner sandbox violation
	econf ${econfargs[*]}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
