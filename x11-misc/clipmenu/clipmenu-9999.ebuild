# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd

DESCRIPTION="Clipboard management"
HOMEPAGE="https://github.com/cdown/clipmenu"
EGIT_REPO_URI="https://github.com/cdown/clipmenu"
EGIT_BRANCH="develop"

LICENSE="MIT"
SLOT="0"
IUSE="+dmenu fzf rofi test"
REQUIRED_USE="?? ( dmenu fzf rofi )"
RESTRICT="!test? ( test )"

DEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
"

RDEPEND="
	${DEPEND}
	dmenu? ( x11-misc/dmenu )
	fzf? ( app-shells/fzf )
	rofi? ( x11-misc/rofi )
"

src_prepare() {
	default

	if use rofi ; then
		sed -i 's|"dmenu"|"rofi"|g' src/config.c || die "sed failed"
	elif use fzf ; then
		sed -i 's|"dmenu"|"fzf"|g'  src/config.c || die "sed failed"
	fi
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
	use test && emake CFLAGS="${CFLAGS}" tests/test_store
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}"/usr \
		systemd_user_dir="${D}/$(systemd_get_userunitdir)"

	einstalldocs
}

src_test() {
	# NOTE(NRK): the "x_integration_tests" are not enabled as they would
	# require additional setup and dependencies
	emake tests
}

pkg_postinst() {
	if systemd_is_booted || has_version sys-apps/systemd; then
		einfo ""
		einfo "Make sure to import \$DISPLAY when using the systemd unit for clipmenud."
		einfo "Please see the README for more details."
	fi

	if ! use dmenu && ! use fzf && ! use rofi ; then
		ewarn ""
		ewarn "Clipmenu has been installed without a launcher."
		ewarn "You will need to set \$CM_LAUNCHER to a dmenu-compatible app for clipmenu to work."
		ewarn "Please refer to the documents for more info."
	fi
}
