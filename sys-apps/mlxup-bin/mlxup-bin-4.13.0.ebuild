# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"
DOC_PV="1.4"

DOC_FILES=(
	"mlxup_user_guide_v${DOC_PV}.pdf"
	"mlxup_release_notes_v${PV}.pdf"
)

DESCRIPTION="Mellanox Update and Query Utility"
HOMEPAGE="https://www.mellanox.com/support/firmware/mlxup-mft"
SRC_URI="
	doc? ( $(for docfile in "${DOC_FILES[@]}"; do
				printf -- 'https://www.mellanox.com/related-docs/prod_software/%s\n' "${docfile}"
			done)
	)
	amd64? ( https://www.mellanox.com/downloads/firmware/${MY_PN}/${PV}/SFX/linux_x64/${MY_PN} -> ${MY_P}-amd64.elf )
	x86? ( https://www.mellanox.com/downloads/firmware/${MY_PN}/${PV}/SFX/linux/${MY_PN} -> ${MY_P}-x86.elf )
"
S="${WORKDIR}"

LICENSE="Mellanox-AS-IS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

QA_PREBUILT="*/${MY_PN}"

src_install() {
	if use amd64; then
		newsbin "${DISTDIR}/${MY_P}-amd64.elf" ${MY_PN}
	elif use x86; then
		newsbin "${DISTDIR}/${MY_P}-x86.elf" ${MY_PN}
	fi

	if use doc; then
		local docfile
		for docfile in "${DOC_FILES[@]}"; do
			dodoc "${DISTDIR}/${docfile}"
		done
	fi
}
