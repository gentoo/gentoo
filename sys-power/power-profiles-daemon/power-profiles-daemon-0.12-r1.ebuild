# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit meson python-single-r1 systemd

DESCRIPTION="Makes power profiles handling available over D-Bus"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/power-profiles-daemon/"
SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gtk-doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
	dev-libs/glib:2
	>=dev-libs/libgudev-234
	>=sys-auth/polkit-0.114
	sys-power/upower
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gi-docgen )
	test? (
		dev-util/umockdev
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	if use test; then
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	else
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	fi
}

src_configure() {
	local emesonargs=(
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(meson_use gtk-doc gtk_doc)
		$(meson_use test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/powerprofilesctl

	newinitd "${FILESDIR}/power-profiles-daemon.initd" power-profiles-daemon
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if systemd_is_booted; then
			elog "You need to enable the service:"
			elog "# systemctl enable ${PN}"
		fi
	fi
}
