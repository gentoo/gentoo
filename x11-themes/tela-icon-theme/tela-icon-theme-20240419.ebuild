# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs edo xdg

MY_PN="${PN^}"
MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}" # eg. 20211225 -> 2021-12-25

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://github.com/vinceliuice/Tela-icon-theme"

if [[ "${PV}" == 99999999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/vinceliuice/Tela-icon-theme.git"
else
	SRC_URI="https://github.com/vinceliuice/Tela-icon-theme/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+hardlink kde minimal"
RESTRICT="binchecks strip test"

BDEPEND="
	app-shells/bash
	hardlink? ( sys-apps/util-linux[hardlink] )
"

DOCS=(
	AUTHORS
	README.md
	tela-dark.png
	tela-light.png
)

tela-icon-theme_check-reqs() {
	if ! use minimal; then
		if use hardlink; then
			CHECKREQS_DISK_USR=1700M
		else
			CHECKREQS_DISK_USR=2600M
		fi

		check-reqs_${EBUILD_PHASE_FUNC}
	fi
}

pkg_setup() {
	tela-icon-theme_check-reqs
}

pkg_pretend() {
	tela-icon-theme_check-reqs
}

src_prepare() {
	default

	# We use eclass for that.
	sed -i "/gtk-update-icon-cache/d" install.sh || die
}

src_install() {
	einstalldocs

	dodir /usr/share/icons

	local options=()

	use kde && options+=( -c )

	if use minimal; then
		options+=( standard )
	else
		options+=( -a )
	fi

	edob ./install.sh -d "${ED}/usr/share/icons" "${options[@]}"

	use hardlink && \
		edob -m "Linking duplicate icons" hardlink -pot "${ED}/usr/share/icons"

	# Installs broken symlinks (by design, but we remove it due to QA warnings).
	# https://bugs.gentoo.org/830467
	edob -m "Removing broken symlinks" find "${ED}" -xtype l -print -delete
}
