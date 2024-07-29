# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo optfeature systemd

DESCRIPTION="SuperMicro IPMI fan control daemon"
HOMEPAGE="https://github.com/chenxiaolong/ipmi-fan-control"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/chenxiaolong/${PN}"
else
	SRC_URI="https://github.com/chenxiaolong/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	# supported boards are x86_64 only, do not keyword elsewhere
	# technically it could run on remote host and issue commands via ipmitool lanplus, but that's very edgy case
	KEYWORDS="-* ~amd64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 GPL-3+ ISC MIT Unicode-DFS-2016 Unlicense"
SLOT="0"

BDEPEND="
	sys-devel/clang
	virtual/pkgconfig
"

RDEPEND="sys-libs/freeipmi"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	cargo_src_install

	sed -i \
		-e "s|@BINDIR@|${EPREFIX}/usr/bin|" \
		-e "s|@SYSCONFDIR@|${EPREFIX}/etc|" \
		dist/ipmi-fan-control.service.in || die

	# TODO: add openrc service
	systemd_newunit dist/ipmi-fan-control.service.in ipmi-fan-control.service

	insinto /etc
	newins config.sample.toml "${PN}".toml
}

pkg_postinst() {
	optfeature "S.M.A.R.T. drive temperature support" sys-apps/smartmontools
}
