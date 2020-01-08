# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Baselayout for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://dev.gentoo.org/~gyakovlev/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

BDEPEND="
	app-crypt/p11-kit[trust]
	app-misc/ca-certificates
"

RDEPEND="${BDEPEND}
	!<dev-java/java-config-2.2"

src_install() {
	default
	keepdir /etc/ssl/certs/java/
	exeinto /etc/ca-certificates/update.d
	newexe - java-cacerts <<-_EOF_
		#!/bin/sh
		exec trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose server-auth "${EROOT}"/etc/ssl/certs/java/cacerts
	_EOF_
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	# on first installation generate java cacert file
	# so jdk ebuilds can create symlink to in into security directory
	if [[ ! -f "${EROOT}"/etc/ssl/certs/java/cacerts ]]; then
		einfo "Generating java cacerts file from system ca-certificates"
		"${EROOT}"/etc/ca-certificates/update.d/java-cacerts || die
	fi
}
