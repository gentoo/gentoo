# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

# eg. 20211225 -> 2021-12-25
MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PN="${PN^}"

# standard comes first
MY_COLOR_VARIANTS=( standard black blue brown green grey orange pink purple red yellow manjaro ubuntu )

inherit xdg

DESCRIPTION="A flat colorful Design icon theme"
HOMEPAGE="https://github.com/vinceliuice/Tela-icon-theme"

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vinceliuice/${MY_PN}.git"
else
	SRC_URI="https://github.com/vinceliuice/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+${MY_COLOR_VARIANTS[*]} +hardlink kde" # this is why standard comes first

REQUIRED_USE="|| ( ${MY_COLOR_VARIANTS[*]} )"

# not needed and slows us down, package installs 120 000 small files
RESTRICT="binchecks strip test"

# technically we can use app-arch/harlink too, but it's deprecated
BDEPEND="
	app-shells/bash
	sys-apps/util-linux[hardlink(-)?]
"

src_prepare() {
	default
	# we use eclass for that
	sed -i '/gtk-update-icon-cache/d' install.sh || die
}

src_install() {
	local v variants=(
		$(usev kde '-c')
		$(for v in ${MY_COLOR_VARIANTS[@]}; do
			usev ${v}
		done)
	)

	dodir /usr/share/icons
	./install.sh -d "${ED}/usr/share/icons" "${variants[@]}" || die
	if use hardlink; then
		einfo "Linking duplicate icons... (may take a long time)"
		hardlink -pot "${ED}/usr/share/icons" || die "hardlink failed"
	fi

	# installs broken symlink (by design, but we remove it due to QA warnings)
	# https://bugs.gentoo.org/830467
	edob find "${ED}" -xtype l -print -delete

	einstalldocs
}
