# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools qmake-utils

DESCRIPTION="Multi-platform helper library for other libraries"
HOMEPAGE="https://www.aquamaniac.de/"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/630/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/79" # correspond with libgwenhywfar.so version
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug gtk qt6 test" # doc (is broken, bug #950614

# broken upstream, reported but got no reply
RESTRICT="test"

RDEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-libs/libxml2:2=
	dev-libs/openssl:0=
	net-libs/gnutls:=
	virtual/libiconv
	virtual/libintl
	gtk? ( x11-libs/gtk+:3 )
	qt6? (
		dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,sql,widgets,xml]
		virtual/opengl
	)
"
DEPEND="${RDEPEND}
	sys-apps/which"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
# doc? ( app-text/doxygen )

PATCHES=( "${FILESDIR}/${PN}-5.12.1-fix-qt6-detect.patch" ) # bug 965843, downstream workaround

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-docpath="${EPREFIX}/usr/share/doc/${PF}/apidoc"
		--with-libxml2-code=yes
		$(use_enable debug)
		#$(use_enable doc full-doc)
	)
	use qt6 && myeconfargs+=(
		--with-qmake="$(qt6_get_bindir)/qmake"
	)

	local guis=()
	use gtk && guis+=( gtk3 )
	use qt6 && guis+=( qt5 ) # yes. qt5.
	QTPATHS="$(qt6_get_bindir)/qtpaths" \
		econf "${myeconfargs[@]}" "--with-guis=${guis[*]}"
}

src_compile() {
	emake
	#use doc && emake srcdoc
}

src_install() {
	default
	#use doc && emake DESTDIR="${D}" install-srcdoc
	find "${D}" -name '*.la' -type f -delete || die
}
