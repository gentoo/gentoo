# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Bash Automated Testing System"
HOMEPAGE="https://github.com/bats-core/bats-core"

LICENSE="MIT"
SLOT="0"

RDEPEND="!dev-util/bats"

src_test() {
	bin/bats --tap test || die "Tests failed"
}

src_install() {
	einstalldocs

	dobin libexec/"${PN}"/*
	doman man/bats.1 man/bats.7
}
