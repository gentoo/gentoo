# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit tmpfiles

DESCRIPTION="Code to work with mmCIF and PDB files"
HOMEPAGE="https://github.com/PDB-REDO/libcifpp"
#SRC_URI="https://github.com/PDB-REDO/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

COMMIT="ec91d0fb222810af0d8a9f7b0810fe7661d227ca"
SRC_URI="https://github.com/PDB-REDO/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	>=dev-libs/boost-1.71:0=
"
DEPEND=""
RDEPEND=""

PATCHES=(
	# https://github.com/PDB-REDO/libcifpp/issues/4
	"${FILESDIR}/${P}-destdir.patch"
)

src_configure() {
	econf \
		--disable-download-ccd \
		--disable-revision \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	rm -r "${ED}"/var/cache/
	dotmpfiles "${FILESDIR}/${PN}.conf"
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
