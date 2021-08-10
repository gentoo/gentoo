# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Python3 support: https://github.com/github/backup-utils/pull/627
PYTHON_COMPAT=(python3_{7,8,9})
inherit python-any-r1

DESCRIPTION="Backup and recovery utilities for GitHub Enterprise"
HOMEPAGE="https://github.com/github/backup-utils"
SRC_URI="https://github.com/github/backup-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# moreutils parallel is now used for speedups in main code:
# https://github.com/github/backup-utils/pull/635
RDEPEND="net-misc/rsync
	sys-apps/moreutils"

# tests invoke parallel & rsync
DEPEND="test? (
	${RDEPEND}
	dev-util/checkbashisms
	${PYTHON_DEPS}
)"

MY_PN="${PN/#github-/}"
S="${WORKDIR}/${MY_PN}-${PV}"

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
