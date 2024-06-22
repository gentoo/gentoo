# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Allow firewalled/NATed host to establish a secure connection"
HOMEPAGE="https://www.gsocket.io/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hackerschoice/gsocket.git"
else
	SRC_URI="https://github.com/hackerschoice/gsocket/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~riscv"
fi

LICENSE="BSD-2"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-libs/openssl:="
DEPEND="
	${COMMON_DEPEND}
	test? (
		net-analyzer/netcat
		net-misc/socat
	)
"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	# https://github.com/hackerschoice/gsocket/pull/104
	"${FILESDIR}"/gsocket-1.4.43-gs-init-secret.patch
)

src_prepare() {
	default

	# Patch in the correct libdir
	sed -i \
		"s;arrayContains \"/usr/lib\".*;DL+=(\"${EPREFIX}/usr/$(get_libdir)\");" \
		tools/gs_funcs || die "Failed to patch libdir in gs_funcs"

	eautoreconf
}

src_configure() {
	econf $(use_enable test tests)
}

src_test() {
	cd tests || die

	./run_ft_tests.sh || die
	# Most of the "gs_tests" seem to fail (probably due the sandbox).
	./run_gs_tests.sh 4.1 || die
}

src_install() {
	default

	systemd_dounit examples/systemd-root-shell/gs-root-shell.service
}
