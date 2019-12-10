# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# See https://github.com/github/backup-utils/issues/135
PYTHON_COMPAT=(python2_7)
inherit python-any-r1

DESCRIPTION="Backup and recovery utilities for GitHub Enterprise"
HOMEPAGE="https://github.com/github/backup-utils"
SRC_URI="https://github.com/github/backup-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
	dev-util/checkbashisms
	sys-apps/moreutils
	${PYTHON_DEPS}
)"

RDEPEND="net-misc/rsync"

MY_PN="${PN/#github-/}"
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default

	# skip a test that depends on a git checkout: https://bugs.gentoo.org/629628
	eapply "${FILESDIR}/github-backup-utils-tarball-fix.patch"

	# Fix for python3 systems
	eapply "${FILESDIR}/github-backup-utils-python27.patch"
}

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
}

src_test() {
	emake test
}
