# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info systemd toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://pagure.io/numad.git"
	inherit git-r3
else
	# sync with fedora (as numad upstream) and add couple of commis.
	# at time of writing f37 uses 20150602
	# git archive --format=tar.gz --prefix="${P}/" -o ${P}.tar.gz ${EGIT_COMMIT}
	EGIT_COMMIT="d696d6c413c5b47b4bbae79e29ea132e52095af3"
	SRC_URI="https://dev.gentoo.org/~gyakovlev/distfiles/${P}.tar.gz"
	KEYWORDS="~amd64 -arm ~arm64 ~ppc64 ~s390 ~x86"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"

CONFIG_CHECK="~NUMA ~CPUSETS"

PATCHES=(
	# https://pagure.io/numad/pull-request/3
	"${FILESDIR}/${PN}-0.5-fix-sparse-node-ids.patch"

	# from debian/ubuntu: https://sources.debian.org/patches/numad
	"${FILESDIR}/${PN}-0.5-fix-build-for-no-NR-migrate-pages.patch"
)

src_configure() {
	tc-export AR CC RANLIB

	# FIXME: https://bugs.gentoo.org/890985
	# temp workaround
	filter-flags -D_FORTIFY_SOURCE=3
	append-cppflags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
}

src_compile() {
	emake OPT_CFLAGS="${CFLAGS}"
}

src_install() {
	emake prefix="${ED}"/usr install

	newinitd "${FILESDIR}"/numad.initd numad
	newconfd "${FILESDIR}"/numad.confd numad

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/numad.logrotated numad

	systemd_dounit numad.service
}
