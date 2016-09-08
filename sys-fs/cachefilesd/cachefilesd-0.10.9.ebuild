# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic systemd toolchain-funcs

DESCRIPTION="Provides a caching directory on an already mounted filesystem"
HOMEPAGE="https://people.redhat.com/~dhowells/fscache/"
SRC_URI="https://people.redhat.com/~dhowells/fscache/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="doc selinux"

RDEPEND="selinux? ( sec-policy/selinux-cachefilesd )"
DEPEND=""

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/${PN}-0.10.9-makefile.patch
	if ! use selinux; then
		sed -e '/^secctx/s:^:#:g' -i cachefilesd.conf || die
	fi

	tc-export CC
	append-flags -fpie
}

src_install() {
	default

	if use selinux; then
		insinto /usr/share/doc/${P}
		doins -r selinux
	fi

	dodoc howto.txt

	newconfd "${FILESDIR}"/${PN}.conf ${PN}
	newinitd "${FILESDIR}"/${PN}-3.init ${PN}

	systemd_dounit ${PN}.service
	systemd_newtmpfilesd "${FILESDIR}"/${PN}-tmpfiles.d ${PN}.conf
}

pkg_postinst() {
	[[ -d /var/cache/fscache ]] && return
	elog "Before CacheFiles can be used, a directory for local storage"
	elog "must be created.  The default configuration of /etc/cachefilesd.conf"
	elog "uses /var/cache/fscache.  The filesystem mounted there must support"
	elog "extended attributes (mount -o user_xattr)."
	echo ""
	elog "Once that is taken care of, start the daemon, add -o ...,fsc"
	elog "to the mount options of your network mounts, and let it fly!"
}
