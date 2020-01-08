# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://pagure.io/numad.git"
	inherit git-r3
else
	EGIT_COMMIT="334278ff3d774d105939743436d7378a189e8693"
	SRC_URI="mirror://gentoo/numad-0.5-${EGIT_COMMIT:0:7}.tar.bz2"
	KEYWORDS="amd64 -arm ~arm64 ~ppc64 -s390 x86"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT:0:7}"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

CONFIG_CHECK="~NUMA ~CPUSETS"

PATCHES=(
	"${FILESDIR}/0001-Fix-man-page-directory-creation.patch"
	"${FILESDIR}/${PN}-0.5-ldlibs.patch"
)

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu99"
}

src_install() {
	emake prefix="${ED}/usr" install

	newinitd "${FILESDIR}/numad.initd" numad
	newconfd "${FILESDIR}/numad.confd" numad

	insinto /etc/logrotate.d
	newins "${FILESDIR}/numad.logrotated" numad

	insinto /etc
	doins numad.conf
	systemd_dounit numad.service
}
