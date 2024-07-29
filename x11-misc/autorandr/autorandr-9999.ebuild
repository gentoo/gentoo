# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 distutils-r1 systemd udev

if [[ "${PV}" = "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/phillipberndt/${PN}.git"
else
	SRC_URI="https://github.com/phillipberndt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Automatically select a display configuration based on connected devices"
HOMEPAGE="https://github.com/phillipberndt/autorandr"

LICENSE="GPL-3"
SLOT="0"
IUSE="launcher systemd udev"

RDEPEND="
	x11-apps/xrandr
	launcher? ( x11-libs/libxcb )
	udev? ( virtual/udev )
"
DEPEND="${RDEPEND}"
# desktop-file-util: uses desktop-file-edit in Makefile
BDEPEND="
	dev-util/desktop-file-utils
	virtual/pkgconfig
"

src_compile() {
	distutils-r1_src_compile

	if use launcher; then
		emake contrib/autorandr_launcher/autorandr-launcher
	fi
}

src_install() {
	distutils-r1_src_install

	doman autorandr.1

	local targets=(
		autostart_config
		bash_completion
		$(usev launcher)
		$(usev systemd)
		$(usev udev)
	)

	emake DESTDIR="${D}" \
		  BASH_COMPLETIONS_DIR="$(get_bashcompdir)" \
		  SYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)" \
		  UDEV_RULES_DIR="$(get_udevdir)"/rules.d \
		  $(printf "install_%s " "${targets[@]}")
}

pkg_postinst() {
	if use udev; then
		udev_reload
	fi
}

pkg_postrm() {
	if use udev; then
		udev_reload
	fi
}
