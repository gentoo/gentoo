# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils systemd toolchain-funcs user

DESCRIPTION="A simple, fast work queue"
HOMEPAGE="http://kr.github.io/beanstalkd/"
SRC_URI="https://github.com/kr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~mips x86 ~amd64-linux ~x64-macos"

RDEPEND=""
DEPEND=""

IUSE=""

DOCS=( README News docs/protocol.txt )

pkg_setup() {
	enewuser beanstalk -1 -1 /var/lib/beanstalkd daemon
}

src_prepare() {
	sed -i -e "s/CFLAGS=/CFLAGS?=/" \
		-e "s/LDLIBS/LDFLAGS/" \
		-e "s/LDFLAGS=/LDFLAGS?=/" Makefile
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dobin beanstalkd

	DATADIR=/var/lib/${PN}
	dodir ${DATADIR}
	fowners beanstalk:daemon ${DATADIR}

	doman doc/"${PN}".1

	newconfd "${FILESDIR}/conf-1.9" beanstalkd
	newinitd "${FILESDIR}/init-1.9" beanstalkd

	systemd_dounit "${S}/adm/systemd/${PN}".{service,socket}
}
