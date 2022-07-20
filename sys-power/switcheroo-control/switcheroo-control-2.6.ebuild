# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit meson python-any-r1

DESCRIPTION="D-Bus service to check the availability of dual-GPU"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/switcheroo-control/"
SRC_URI="https://gitlab.freedesktop.org/hadess/switcheroo-control/uploads/86ea54ac7ddb901b6bf6e915209151f8/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk-doc test"

KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgudev-232:=
	sys-apps/systemd
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
	test? (
	        $(python_gen_any_dep 'dev-python/python-dbusmock[${PYTHON_USEDEP}]')
		dev-util/umockdev
	)
"

RESTRICT="!test? ( test )"

python_check_deps() {
	use test || return 0
	has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)
	meson_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You need to run systemd and enable the service:"
		elog "# systemctl enable switcheroo-control"
	fi
}
