# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Reference Implementation of The Jolly Good API"
HOMEPAGE="https://jgemu.gitlab.io/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="ZLIB"
SLOT="1"

src_compile() {
	: # Nothing to do
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
}
