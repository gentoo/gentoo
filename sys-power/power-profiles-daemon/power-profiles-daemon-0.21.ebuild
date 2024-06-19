# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit meson python-single-r1 shell-completion systemd

DESCRIPTION="Makes power profiles handling available over D-Bus"
HOMEPAGE="https://gitlab.freedesktop.org/upower/power-profiles-daemon/"
SRC_URI="https://gitlab.freedesktop.org/upower/${PN}/-/archive/${PV}/${P}.tar.bz2"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~x86"

IUSE="bash-completion gtk-doc man selinux test zsh-completion"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
	dev-libs/glib:2
	>=dev-libs/libgudev-234
	>=sys-auth/polkit-0.99
	sys-power/upower
	selinux? ( sec-policy/selinux-powerprofiles )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	bash-completion? (
		>=app-shells/bash-completion-2.0
		$(python_gen_cond_dep '>=dev-python/shtab-1.7.0[${PYTHON_USEDEP}]')
	)
	gtk-doc? (
		dev-util/gi-docgen
		dev-util/gtk-doc
	)
	man? (
		$(python_gen_cond_dep 'dev-python/argparse-manpage[${PYTHON_USEDEP}]')
	)
	test? (
		dev-util/umockdev
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
	zsh-completion? (
		$(python_gen_cond_dep '>=dev-python/shtab-1.7.0[${PYTHON_USEDEP}]')
	)
"

python_check_deps() {
	if use test; then
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]" &&
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	else
		python_has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
	fi

	if use bash-completion || use zsh-completion; then
		python_has_version ">=dev-python/shtab-1.7.0[${PYTHON_USEDEP}]"
	fi

	use man && python_has_version "dev-python/argparse-manpage[${PYTHON_USEDEP}]"
}

src_configure() {
	local emesonargs=(
		-Dpylint=disabled
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(meson_feature bash-completion bashcomp)
		$(meson_use gtk-doc gtk_doc)
		$(meson_feature man manpage)
		$(meson_use test tests)
	)
	use zsh-completion && emesonargs+=( -Dzshcomp="$(get_zshcompdir)" )
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/powerprofilesctl
	newinitd "${FILESDIR}/power-profiles-daemon.initd" power-profiles-daemon
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You need to enable the service:"
		if systemd_is_booted; then
			elog "# systemctl enable ${PN}"
		else
			elog "# rc-update add ${PN} default"
		fi
	fi
}
