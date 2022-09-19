# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="TUI greeter for greetd login manager"
HOMEPAGE="https://github.com/apognu/tuigreet"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apognu/${PN}"
else
	SRC_URI="https://github.com/apognu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~ppc64 ~riscv"
fi

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

QA_FLAGS_IGNORED="usr/bin/tuigreet"

LICENSE="Apache-2.0 Boost-1.0 GPL-3 MIT"
SLOT="0"

RDEPEND="acct-group/greetd
	acct-user/greetd
	gui-libs/greetd"
DEPEND="${RDEPEND}"

src_install() {
	dodir /var/cache/${PN}
	fowners greetd:greetd /var/cache/${PN}
	keepdir /var/cache/${PN}

	cargo_src_install
}
