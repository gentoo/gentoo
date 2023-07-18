# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/zapper/zap}

DESCRIPTION="Redirector for squid to intercept advertising, page counters and web bugs"
HOMEPAGE="https://adzapper.sourceforge.net/"
SRC_URI="https://adzapper.sourceforge.net/${MY_P}.tar.gz"
S="${WORKDIR}"/${P/per/}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc sparc x86"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/20110915-flush.patch
)

src_prepare() {
	default

	# update the zapper path in various scripts
	local SCRPATH="/etc/adzapper/squid_redirect"
	sed -i \
		-e "s|^zapper=.*|zapper=${SCRPATH}|" \
		-e "s|^ZAPPER=.*|ZAPPER=\"${SCRPATH}\"|" \
		-e "s|^pidfile=.*|pidfile=/var/run/squid.pid|" \
		-e "s|^PIDFILE=.*|PIDFILE=\"/var/run/squid.pid\"|" \
		-e "s|^RESTARTCMD=.*|RESTARTCMD=\"/etc/init.d/squid restart\"|" \
		scripts/wrapzap scripts/update-zapper* \
		|| die "sed updating failed."
}

src_install() {
	exeinto /etc/adzapper
	doexe \
		scripts/wrapzap \
		scripts/zapchain \
		adblock-plus/adblockplus2adzapper.py
	newexe scripts/squid_redirect-nodata squid_redirect

	insinto /etc/adzapper
	doins scripts/update-zapper*

	insinto /var/www/localhost/htdocs/zap
	doins zaps/*
}

pkg_postinst() {
	einfo "To enable adzapper, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /etc/adzapper/wrapzap"
	einfo "    url_rewrite_children 10"
}
