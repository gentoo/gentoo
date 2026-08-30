# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit linux-info meson shell-completion python-any-r1

DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/containers/bubblewrap/"
SRC_URI="https://github.com/containers/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/libcap
	selinux? ( >=sys-libs/libselinux-2.3 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xml-dtd:4.3
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			sys-libs/libseccomp[python,${PYTHON_USEDEP}]
		')
	)
"
RDEPEND+=" selinux? ( sec-policy/selinux-bubblewrap )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.2-no-werror.patch
)

python_check_deps() {
	python_has_version "sys-libs/libseccomp[python,${PYTHON_USEDEP}]"
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		CONFIG_CHECK="~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS"
		linux-info_pkg_setup
	fi

	use test && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		# We could write up -Dassume_kernel like in glibc if
		# someone is interested
		-Dbash_completion=enabled
		-Dbash_completion_dir="$(get_bashcompdir)"
		-Dzsh_completion=enabled
		-Dzsh_completion_dir="$(get_zshcompdir)"
		-Dman=enabled
		$(meson_feature selinux)
		$(meson_use test tests)
	)

	use test && emesonargs+=( -Dpython="${EPYTHON}" )

	meson_src_configure
}

src_test() {
	# Most tests are skipped if sandbox is enabled
	local -x SANDBOX_ON=0
	meson_src_test
}
