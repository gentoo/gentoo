# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-r1 readme.gentoo-r1 systemd

MY_P="${PN}_${PV/_/}"

DESCRIPTION="Proxy cache for Gentoo packages"
HOMEPAGE="https://sourceforge.net/projects/http-replicator"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ppc ~sparc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-apps/portage[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

# Tests downloads files as well as breaks, should be turned into local tests.
RESTRICT="test"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Before starting ${PN}, please follow the next few steps:

- Modify /etc/conf.d/${PN} if required.
- Run \`repcacheman\` to set up the cache.
- Add HTTP_PROXY=\"http://serveraddress:8080\" to make.conf on
the server as well as on the client machines.
- Make sure GENTOO_MIRRORS in /etc/portage/make.conf
starts with several good HTTP mirrors.

For more information please refer to the following forum thread:
https://forums.gentoo.org/viewtopic-t-173226.html

Starting with 4.x releases, the conf.d parameters have changed.
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0_alpha2-r3-pid.patch
	"${FILESDIR}"/${PN}-4.0_alpha2-ipv6.patch #669078
)

src_test() {
	./unit-test && die
}

src_install() {
	python_foreach_impl python_doscript http-replicator

	newbin "${FILESDIR}"/${PN}-3.0-callrepcacheman-0.1 repcacheman

	python_foreach_impl python_domodule *.py

	python_foreach_impl python_newscript "${FILESDIR}"/${PN}-3.0-repcacheman-0.44-r2 repcacheman.py

	newinitd "${FILESDIR}"/${PN}-4.0_alpha2-r3.init http-replicator
	newconfd "${FILESDIR}"/${PN}-4.0_alpha2-r2.conf http-replicator

	systemd_dounit "${FILESDIR}"/http-replicator.service
	systemd_install_serviced "${FILESDIR}"/http-replicator.service.conf

	dodoc README.user README.devel RELNOTES
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
