# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Gitlab CI notice (vendor crates):
# https://gitlab.com/api/v4/projects/72067412 points to:
# https://gitlab.com/ZaPpPeL/git-cliff-crates/-/packages

EAPI=8

RUST_MIN_VER="1.85.1"

inherit cargo shell-completion

DESCRIPTION="A highly customizable changelog generator"
HOMEPAGE="https://git-cliff.org/"
SRC_URI="
	https://github.com/orhun/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://gitlab.com/api/v4/projects/72067412/packages/generic/${PN}/${PV}/${P}-crates.tar.xz
"

LICENSE="Apache-2.0 BSD-2 BSD Boost-1.0 CDDL CDLA-Permissive-2.0 ISC MIT
	MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	# disables tests against local (.)git repo
	"${FILESDIR}/${PN}-2.10.0-disable_repo_tests.patch"
	# silences a "command not found" error (QA)
	"${FILESDIR}/${PN}-2.10.0-silence_run_os_command_test.patch"
)

src_compile() {
	cargo_src_compile

	local target_dir="${S}/$(cargo_target_dir)"

	# generating man pages
	mkdir -p "${target_dir}/man" || die
	OUT_DIR="${target_dir}/man" "${target_dir}/"${PN}-mangen || die

	# generating completion scripts
	mkdir -p "${target_dir}/completion" || die
	OUT_DIR="${target_dir}/completion" "${target_dir}/"${PN}-completions || die
}

src_install() {
	local release_dir="${S}/$(cargo_target_dir)"

	insinto /usr/bin
	dobin "${release_dir}/"${PN}

	doman "${release_dir}/man/"${PN}.1

	newbashcomp "${release_dir}/completion/${PN}.bash" ${PN}
	newfishcomp "${release_dir}/completion/${PN}.fish" ${PN}

	einstalldocs
	dodoc -r "${S}"/examples/
}
