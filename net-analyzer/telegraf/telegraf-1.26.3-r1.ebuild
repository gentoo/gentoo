# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
MY_PV="${PV/_rc/-rc.}"
COMMIT=90f4eb29
BRANCH=HEAD
VERSION=v${MY_PV}

DESCRIPTION="The plugin-driven server agent for collecting & reporting metrics"
HOMEPAGE="https://github.com/influxdata/telegraf"

SRC_URI="https://github.com/influxdata/telegraf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT+=" test"

DEPEND="acct-group/telegraf
	acct-user/telegraf"
	RDEPEND="${DEPEND}"

src_compile() {
	unset LDFLAGS
	emake -j1 \
		COMMIT=${COMMIT} \
		BRANCH=${BRANCH} \
		VERSION=v${MY_PV}
}

src_install() {
	dobin telegraf
	insinto /etc/logrotate.d
	doins etc/logrotate.d/telegraf
	keepdir /etc/telegraf
	keepdir /etc/telegraf/telegraf.d
	systemd_dounit scripts/telegraf.service
	newconfd "${FILESDIR}"/telegraf.confd telegraf
	newinitd "${FILESDIR}"/telegraf.rc telegraf
	dodoc -r *.md docs
	keepdir /var/log/telegraf
	fowners telegraf:telegraf /var/log/telegraf
}
