# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Embeddable Javascript engine"
HOMEPAGE="https://duktape.org"
SRC_URI="https://duktape.org/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	# Set install path
	sed -i "s#INSTALL_PREFIX=/usr/local#INSTALL_PREFIX=${D::-1}/usr#" \
			Makefile.sharedlibrary || die "failed to set install path"

	# Edit pkgconfig
	sed "s#VERSION#${PV}#" "${FILESDIR}/${PN}.pc" > "${S}/${PN}.pc" || die
	sed -i "s#LIBDIR#$(get_libdir)#" "${S}/${PN}.pc" || die

	# Set lib folder
	sed -i "s#(INSTALL_PREFIX)/lib#(INSTALL_PREFIX)/$(get_libdir)#" \
		Makefile.sharedlibrary || die

	mv Makefile.sharedlibrary Makefile || die "failed to rename makefile"
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/include
	emake install

	insinto /usr/$(get_libdir)/pkgconfig/
	doins "${S}/${PN}.pc"
}
