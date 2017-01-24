# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit systemd

DESCRIPTION="Agent to report data to Check_MK for monitoring"
HOMEPAGE="http://mathias-kettner.de/check_mk.html"

MY_PV="${PV/_p/p}"
MY_P="check_mk-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apache_status logwatch mysql nfsexports oracle postgres smart +xinetd zypper"

RDEPEND="!!net-analyzer/check_mk
	app-shells/bash:*
	xinetd? ( || ( sys-apps/xinetd sys-apps/systemd ) )
	"
DEPEND="${RDEPEND}"

SRC_URI="http://mathias-kettner.de/download/${MY_P}.tar.gz"

src_unpack() {
	# check_mk is a tarball containing tarballs
	unpack ${A}
	mkdir -p "${S}" || die
	cd "${S}" || die
	unpack "${WORKDIR}"/${MY_P}/agents.tar.gz
	mkdir -p "${S}"/doc || die
	cd "${S}"/doc || die
	unpack "${WORKDIR}"/${MY_P}/doc.tar.gz
}

src_prepare() {
	cat <<EOF >Makefile
all: waitmax

waitmax: waitmax.c
	\$(CC) \$(CFLAGS) \$< -o \$@ \$(LDFLAGS)

EOF

	if [[ -f waitmax ]]; then
		rm waitmax || die "Couldn't delete precompiled waitmax file"
	fi

	default
}

src_compile() {
	# compile waitmax
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	# Install agent related files
	newbin check_mk_agent.linux check_mk_agent
	dobin waitmax

	keepdir /usr/lib/check_mk_agent/local
	dodir /usr/lib/check_mk_agent/plugins
	dodir /etc/check_mk

	dodoc doc/{AUTHORS,COPYING,ChangeLog}
	docompress

	if use xinetd; then
		insinto /etc/xinetd.d
		newins cfg_examples/xinetd.conf check_mk
		systemd_dounit cfg_examples/systemd/check_mk{.socket,@.service}
	fi

	# Install the check_mk_agent logwatch plugin
	if use logwatch; then
		insinto /etc/check_mk
		doins cfg_examples/logwatch.cfg
		exeinto /usr/lib/check_mk_agent/plugins
		doexe plugins/mk_logwatch
	fi

	# Install any other useflag-enabled agent plugins
	exeinto /usr/lib/check_mk_agent/plugins
	use smart && doexe plugins/smart
	use mysql && doexe plugins/mk_mysql
	use postgres && doexe plugins/mk_postgres
	use apache_status && doexe plugins/apache_status
	use zypper && doexe plugins/mk_zypper
	use oracle && doexe plugins/mk_oracle
	use nfsexports && doexe plugins/nfsexports
}
