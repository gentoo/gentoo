# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C/C++ toolkit for Z39.50v3 clients and servers"
HOMEPAGE="https://www.indexdata.com/resources/software/yaz/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/indexdata/yaz.git"
else
	SRC_URI="https://ftp.indexdata.com/pub/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="BSD"
SLOT="0/5"
IUSE="memcached redis tcpd"

RDEPEND="
	dev-libs/icu:=
	dev-libs/libxml2:=
	dev-libs/libxslt
	net-libs/gnutls:=
	sys-libs/readline:=
	virtual/libintl
	memcached? (
		|| (
			dev-libs/libmemcached-awesome
			dev-libs/libmemcached
		)
	)
	redis? ( dev-libs/hiredis:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	dev-build/libtool:2
	dev-lang/tcl:0
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-fix_musl.patch
)

DOCS=( NEWS README.md )

src_prepare() {
	default

	# Hardcoded assumption of libraries residing in lib/,  bug #730016
	sed -i -e "s|/lib\"|/$(get_libdir)\"|" configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with memcached)
		$(use_with redis)
		$(use_enable tcpd tcpd /usr)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		docdir="${EPREFIX}/usr/share/doc/${PF}/html"
		# move common dir in html
		PACKAGE_SUFFIX="-${PVR}/html"
	)
	emake "${myemakeargs[@]}" install

	find "${D}" -name '*.la' -delete || die

	einstalldocs
}
