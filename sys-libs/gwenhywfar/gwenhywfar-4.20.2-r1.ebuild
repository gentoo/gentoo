# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Multi-platform helper library for other libraries"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/108/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/60" # correspond with libgwenhywfar.so version
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug designer doc fox gtk libressl qml qt5 sensors serialport test webkit"

REQUIRED_USE="designer? ( qt5 ) qml? ( qt5 ) sensors? ( qt5 ) serialport? ( qt5 ) webkit? ( qt5 )"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
COMMON_DEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	net-libs/gnutls:=
	virtual/libiconv
	virtual/libintl
	virtual/opengl
	designer? ( dev-qt/designer:5 )
	fox? ( x11-libs/fox:1.6 )
	gtk? ( x11-libs/gtk+:3 )
	qml? ( dev-qt/qtdeclarative:5 )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
	)
	sensors? ( dev-qt/qtsensors:5 )
	serialport? ( dev-qt/qtserialport:5 )
	webkit? ( dev-qt/qtwebkit:5 )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${COMMON_DEPEND}
	gtk? ( !<app-office/gnucash-3.7[aqbanking] )
"

# broken upstream, reported but got no reply
RESTRICT="test"

src_configure() {
	disableQtModule() {
		local module
		for module in ${@}; do
			sed -e "/qtHaveModule(${module})/s|^|#DONT|" -i configure || die
		done
	}

	use designer || disableQtModule designer uitools
	use qml || disableQtModule qml qmltest
	use sensors || disableQtModule sensors
	use serialport || disableQtModule serialport
	use test || disableQtModule testlib
	use webkit || disableQtModule webkit webkitwidgets

	local guis=()
	use fox && guis+=( fox16 )
	use gtk && guis+=( gtk3 )
	use qt5 && guis+=( qt5 )

	local myeconfargs=(
		--enable-ssl
		$(use_enable debug)
		$(use_enable doc full-doc)
		--with-docpath="${EPREFIX}/usr/share/doc/${PF}/apidoc"
	)
	use qt5 && myeconfargs+=(
		--with-qt5-moc="$(qt5_get_bindir)/moc"
		--with-qt5-qmake="$(qt5_get_bindir)/qmake"
	)

	guis_config="--with-guis=${guis[@]}"
	econf "${myeconfargs[@]}" "${guis_config}"
}

src_compile() {
	emake
	use doc && emake srcdoc
}

src_install() {
	default
	use doc && emake DESTDIR="${D}" install-srcdoc
	find "${ED}" -name '*.la' -delete || die
}
