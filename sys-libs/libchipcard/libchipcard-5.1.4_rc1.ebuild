# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_rc/rc}"

DESCRIPTION="Library for accessing chip cards via chip card readers (terminals)"
HOMEPAGE="https://www.aquamaniac.de/rdm/projects/libchipcard"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/221/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="doc examples"

BDEPEND="
	sys-devel/gettext
	doc? ( app-doc/doxygen )
"
DEPEND="
	>=sys-apps/pcsc-lite-1.6.2
	>=sys-libs/gwenhywfar-4.99.22_rc6:=
	sys-libs/zlib
	virtual/libintl
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO doc/{CERTIFICATES,CONFIG,IPCCOMMANDS} )

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myeconfargs=(
		--disable-static
		--with-docpath=/usr/share/doc/${PF}/apidoc
		$(use_enable doc full-doc)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	einstalldocs

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h,xml} tutorials/README
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
