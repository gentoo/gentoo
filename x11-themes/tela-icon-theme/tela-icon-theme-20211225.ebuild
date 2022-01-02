# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# eg. 20211225 -> 2021-12-25
MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"
MY_PN="${PN/t/T}"

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
IUSE="${MY_COLOR_VARIANTS[*]/standard/+standard}"

REQUIRED_USE="|| ( ${MY_COLOR_VARIANTS[*]} )"

RESTRICT="binchecks strip test" # not needed

BDEPEND="app-shells/bash"

src_prepare() {
	default
	# we use eclass for that
	sed -i '/gtk-update-icon-cache/d' install.sh || die
}

src_install() {
	local v variants=(
		$(
			for v in ${MY_COLOR_VARIANTS[@]}; do
				usev ${v}
			done
		)
	)

	dodir /usr/share/icons
	./install.sh -d "${ED}/usr/share/icons" "${variants[@]}" || die

	einstalldocs
}
