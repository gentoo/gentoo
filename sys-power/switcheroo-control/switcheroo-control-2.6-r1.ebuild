# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit meson python-any-r1 systemd

DESCRIPTION="D-Bus service to check the availability of dual-GPU"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/switcheroo-control/"
SRC_URI="https://gitlab.freedesktop.org/hadess/switcheroo-control/uploads/86ea54ac7ddb901b6bf6e915209151f8/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk-doc test systemd"

KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgudev-232:=
	systemd? ( sys-apps/systemd )
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
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)

	# to keep meson happy without systemd dependency
	if ! use systemd ; then
		emesonargs+=( -Dsystemdsystemunitdir="$(systemd_get_systemunitdir)" )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/switcherooctl

	if ! use systemd; then
		newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	fi;
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] && use systemd ; then
		elog "You need to run systemd and enable the service:"
		elog "# systemctl enable switcheroo-control"
	fi
}
