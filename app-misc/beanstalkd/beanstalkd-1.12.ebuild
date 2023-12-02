# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="A simple, fast work queue"
HOMEPAGE="https://kr.github.io/beanstalkd/"
SRC_URI="https://github.com/kr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips x86 ~amd64-linux ~x64-macos"

RDEPEND="
	acct-group/beanstalk
	acct-user/beanstalk
"

DOCS=( README News docs/protocol.txt )

src_prepare() {
	default
	sed -e "/override/d" -i Makefile || die
}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dobin beanstalkd

	doman doc/"${PN}".1

	newconfd "${FILESDIR}/conf-1.9" beanstalkd
	newinitd "${FILESDIR}/init-1.9" beanstalkd

	systemd_dounit "${S}/adm/systemd/${PN}".{service,socket}
}
