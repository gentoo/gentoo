# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Golang implementation of Graphite/Carbon server"
HOMEPAGE="https://github.com/go-graphite/go-carbon"
SRC_URI="https://github.com/go-graphite/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	acct-group/carbon
	acct-user/carbon"
BDEPEND=""

src_prepare() {
	export BUILD="gentoo-${PVR}"

	# bug 904050: -race conflicts with -buildmode=pie added by go-module
	sed -i \
		-e '/make run-test COMMAND="test -race"/d' \
		-e '/make run-test COMMAND="vet"/d' \
		Makefile || die

	eapply_user
}

src_install() {
	insinto /etc/go-carbon
	doins "${S}"/go-carbon.conf.example
	dobin go-carbon

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
