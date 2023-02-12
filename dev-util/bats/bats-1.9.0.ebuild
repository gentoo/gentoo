# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing optfeature

MY_PN="bats-core"
DESCRIPTION="Bats-core: Bash Automated Testing System"
HOMEPAGE="https://github.com/bats-core/bats-core/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="app-shells/bash:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_test() {
	local my_jobs=$(get_nproc)
	if ! command -v parallel >/dev/null; then
		my_jobs=1
	fi
	bin/bats --tap --jobs "${my_jobs}" test || die "Tests failed"
}

src_install() {
	exeinto /usr/libexec/${MY_PN}
	doexe libexec/${MY_PN}/*
	exeinto /usr/lib/${MY_PN}
	doexe lib/${MY_PN}/*
	dobin bin/${PN}

	dodoc README.md
	doman man/${PN}.1 man/${PN}.7
}

pkg_postinst() {
	optfeature "Parallel Execution" sys-process/parallel
}
