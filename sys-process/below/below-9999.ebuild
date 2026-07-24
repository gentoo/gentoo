# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
RUST_REQ_USE="rustfmt"

inherit cargo systemd

DESCRIPTION="An interactive tool to view and record historical system data"
HOMEPAGE="https://github.com/facebookincubator/below"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/facebookincubator/below.git"
	SRC_URI="
		https://github.com/facebookincubator/below/commit/1ceedbeed2eb69b36831179ae418712b237192d9.patch
			-> below-0.12-swallow-invalid-file-format.patch
		https://github.com/facebookincubator/below/commit/414ba9bad84bec1236f9756f7732fb4cc5ee0b18.patch
			-> below-0.12-fix-incompatible-pointer-types.patch
	"
else
	SRC_URI="
		https://github.com/facebookincubator/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0"
LICENSE+=" BSD-2 BSD ISC MIT Unicode-DFS-2016 Unlicense"

SLOT="0"

BDEPEND="
	llvm-core/clang
	virtual/pkgconfig
"
RDEPEND="
	app-arch/zstd:=
	virtual/zlib:=
	virtual/libelf:=
"
DEPEND="
	${RDEPEND}
	sys-libs/ncurses
"

QA_FLAGS_IGNORED="usr/bin/below"

PATCHES=(
	# https://github.com/facebookincubator/below/pull/8285
	"${DISTDIR}"/below-0.12-swallow-invalid-file-format.patch
	# https://github.com/facebookincubator/below/pull/8280
	"${DISTDIR}"/below-0.12-fix-incompatible-pointer-types.patch
)

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	export ZSTD_SYS_USE_PKG_CONFIG=1

	cargo_src_configure
}

src_test() {
	local CARGO_SKIP_TESTS=(
		disable_disk_stat
		advance_forward_and_reverse
		disable_io_stat
		record_replay_integration
		test_belowrc_to_event
	)
	cargo_src_test --workspace below
}

src_install() {
	cargo_src_install --path below

	keepdir /var/log/below

	systemd_dounit "etc/${PN}.service"
	newinitd "${FILESDIR}/${PN}-r1.initd" below
	newconfd "${FILESDIR}/${PN}.confd" below

	insinto /etc/logrotate.d
	newins etc/logrotate.conf below

	dodoc -r docs
}
