# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Multi-platform helper library for other libraries"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/533/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/79" # correspond with libgwenhywfar.so version
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug gtk qt6 test" # doc (is broken, bug #950614

# broken upstream, reported but got no reply
RESTRICT="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-libs/libxml2:2=
	dev-libs/openssl:0=
	net-libs/gnutls:=
	virtual/libiconv
	virtual/libintl
	virtual/opengl
	gtk? ( x11-libs/gtk+:3 )
	qt6? ( dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl,sql,widgets,xml] )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
# doc? ( app-text/doxygen )

src_configure() {
	local myeconfargs=(
		--with-docpath="${EPREFIX}/usr/share/doc/${PF}/apidoc"
		--with-libxml2-code=yes
		$(use_enable debug)
		#$(use_enable doc full-doc)
	)
# 	use qt6 && myeconfargs+=(
# 		--with-qt6-moc="$(qt6_get_libdir)/qt6/libexec/moc"
# 		--with-qt6-qmake="$(qt6_get_bindir)/qmake"
# 	)

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
