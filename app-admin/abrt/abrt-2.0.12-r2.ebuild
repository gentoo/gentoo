# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

# Need gnome2-utils for gnome2_icon_cache_update
inherit autotools eutils gnome2-utils python-single-r1 systemd user

DESCRIPTION="Automatic bug detection and reporting tool"
HOMEPAGE="https://fedorahosted.org/abrt/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/btparser-0.18
	>=dev-libs/glib-2.21:2
	>=dev-libs/libreport-2.0.11[${PYTHON_USEDEP}]
	dev-libs/libxml2
	dev-libs/nss
	sys-apps/dbus
	sys-auth/polkit
	sys-fs/inotify-tools
	x11-libs/gtk+:3
	x11-libs/libnotify"
RDEPEND="${COMMON_DEPEND}
	app-arch/cpio
	dev-libs/elfutils
	>=sys-devel/gdb-7"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	>=sys-devel/gettext-0.17"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	python-single-r1_pkg_setup

	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	# Disable redhat-specific code not usable in gentoo, or that requires
	# bugs.gentoo.org infra support.
	epatch "${FILESDIR}/${PN}-2.0.12-gentoo.patch"

	# Using a server response as a format string is a bad idea
	epatch "${FILESDIR}/${PN}-2.0.6-format-security.patch"

	# pyhook test is sensitive to the format of python's error messages, and
	# fails with certain python versions
	sed -e '/pyhook.at/ d' \
		-i tests/Makefile.* tests/testsuite.at || die "sed 2 failed"

	# automake-1.12, #427926
	epatch "${FILESDIR}/${PN}-2.0.12-automake-1.12.patch"

	# Fix dbus timeout in gui; in next release
	epatch "${FILESDIR}/${P}-dbus-fallback.patch"

	eautoreconf

	python_fix_shebang .
}

src_configure() {
	myeconfargs=(
		"--localstatedir=${EPREFIX}/var"
		"$(systemd_with_unitdir)"
	)
	# --disable-debug enables debug!
	use debug && myeconfargs=( "${myeconfargs[@]}" --enable-debug )
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	keepdir /var/run/abrt
	# /var/spool/abrt is created by dev-libs/libreport

	diropts -m 700 -o abrt -g abrt
	keepdir /var/spool/abrt-upload

	diropts -m 775 -o abrt -g abrt
	keepdir /var/cache/abrt-di

	find "${D}" -name '*.la' -exec rm -f {} + || die

	newinitd "${FILESDIR}/${PN}-2.0.12-r1-init" abrt
	newconfd "${FILESDIR}/${PN}-2.0.12-r1-conf" abrt
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "To start the bug detection service on an openrc-based system, do"
	elog "# /etc/init.d/abrt start"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
