# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# PYTHON_COMPAT=( python3_{10..12} )
# inherit python-any-r1

DESCRIPTION="Backup and recovery utilities for GitHub Enterprise"
HOMEPAGE="https://github.com/github/backup-utils"
SRC_URI="https://github.com/github/backup-utils/releases/download/v${PV}/${PN}-v${PV}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests restricted due to bug #796815
RESTRICT="test"

# moreutils parallel is now used for speedups in main code:
# https://github.com/github/backup-utils/pull/635
RDEPEND="app-misc/jq
	app-arch/pigz
	net-misc/rsync
	sys-apps/moreutils"

# tests invoke parallel & rsync
# DEPEND="test? (
#	${RDEPEND}
#	dev-util/checkbashisms
#	${PYTHON_DEPS}
#)"

# pkg_setup() {
#	use test && python-any-r1_pkg_setup
#}

src_compile() {
	:;
}

src_install() {
	dobin bin/*
	insinto usr/share/${PN}
	doins share/${PN}/version

	exeinto usr/share/${PN}
	doexe share/${PN}/bm.sh
	doexe share/${PN}/ghe-*

	insinto etc/${PN}
	newins backup.config-example backup.config

	dodoc -r docs/*
}

src_test() {
	emake test
}
