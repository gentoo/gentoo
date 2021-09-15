# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Free and open source log management"
HOMEPAGE="https://www.graylog.org"
SRC_URI="https://downloads.graylog.org/releases/graylog/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
RESTRICT="strip"

RDEPEND="!app-admin/graylog2
	acct-group/graylog
	acct-user/graylog
	>=virtual/jdk-1.8:*"

DOCS=(
	README.markdown UPGRADING.rst
)

GRAYLOG_DATA_DIR="/var/lib/graylog"
GRAYLOG_INSTALL_DIR="/usr/share/graylog"
QA_PREBUILT="${GRAYLOG_INSTALL_DIR}/lib/sigar/libsigar*"

src_prepare() {
	default

	# gentoo specific paths
	sed -i "s@\(node_id_file = \).*@\1${GRAYLOG_DATA_DIR}/node-id@g; \
		s@\(message_journal_dir = \).*@\1${GRAYLOG_DATA_DIR}/data/journal@g;" \
		graylog.conf.example || die
}

src_install() {
	default

	insinto /etc/graylog
	doins graylog.conf.example

	insinto "${GRAYLOG_INSTALL_DIR}"
	doins graylog.jar
	doins -r plugin

	keepdir "${GRAYLOG_DATA_DIR}"

	newconfd "${FILESDIR}/graylog.confd" graylog
	newinitd "${FILESDIR}/graylog.initd" graylog
}

pkg_postinst() {
	ewarn "Graylog does not depend on need.net any more (#439092)."
	ewarn
	ewarn "Please configure rc_need according to your binding address in:"
	ewarn "/etc/conf.d/graylog"
}
