# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a highly configurable program for managing and archiving log files"
HOMEPAGE="http://www.weird.com/~woods/projects/newsyslog.html"
SRC_URI="http://download.openpkg.org/components/cache/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 ~sparc x86"

BDEPEND="sys-apps/groff"
RDEPEND="
	virtual/cron
	app-arch/gzip"

PATCHES=(
	"${FILESDIR}"/${P}-html.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	local myconf=(
		--with-gzip
		--with-newsyslog_conf="${EPREFIX}"/etc/newsyslog.conf
	)
	if has_version 'app-admin/syslog-ng'; then
		myconf+=( --with-syslogd_pid="${EPREFIX}"/var/run/syslog-ng.pid )
	else
		myconf+=( --with-syslogd_pid="${EPREFIX}"/var/run/syslog.pid )
	fi

	econf "${myconf[@]}"
}

src_install() {
	# The "install" target would install cached man pages #840951
	emake \
		DESTDIR="${D}" \
		install-exec install-man

	einstalldocs
	dodoc newsyslog.conf ToDo
}
