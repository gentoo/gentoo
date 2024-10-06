# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools and libraries to access human-editable, plain text databases"
HOMEPAGE="https://www.gnu.org/software/recutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="crypt curl mdb nls"

RDEPEND="
	sys-libs/readline:=
	kernel_linux? ( sys-apps/util-linux )
	crypt? (
		dev-libs/libgcrypt:=
		dev-libs/libgpg-error
	)
	curl? ( net-misc/curl )
	mdb? (
		app-office/mdbtools:=
		dev-libs/glib:2
	)
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PV}
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	export LEX=flex

	local myeconfargs=(
		--enable-uuid
		$(use_enable crypt encryption)
		$(use_enable curl)
		$(use_enable mdb)
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# tests have parallel issues
	emake -j1 check
}
