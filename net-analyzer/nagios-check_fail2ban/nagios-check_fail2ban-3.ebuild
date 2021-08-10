# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="check_fail2ban"
GITHUB_COMMIT="c554837"

DESCRIPTION="A nagios plugin for checking the fail2ban daemon"
HOMEPAGE="https://github.com/hollow/check_fail2ban"
SRC_URI="https://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="|| ( >=net-analyzer/nagios-plugins-1.4.13-r1 >=net-analyzer/monitoring-plugins-2 )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
}
