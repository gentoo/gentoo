# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Embeddable Javascript engine"
HOMEPAGE="http://duktape.org"
SRC_URI="http://duktape.org/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	sed -i "s#INSTALL_PREFIX=/usr/local#INSTALL_PREFIX=${D::-1}/usr#" \
			Makefile.sharedlibrary || die "failed to sed makefile"

	cp "${FILESDIR}/${PN}.pc" "${WORKDIR}" || die
	sed -i "s#VERSION#${PV}#" "${WORKDIR}/${PN}.pc" || die

	mv Makefile.sharedlibrary Makefile || die "faile to mv makefile"
}

src_install() {
	dodir "/usr/lib"
	dodir "/usr/include"
	emake install
}
