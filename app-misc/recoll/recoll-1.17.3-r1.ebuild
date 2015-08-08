# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_DEPEND="2"
inherit toolchain-funcs qt4-r2 linux-info python

DESCRIPTION="A personal full text search package"
HOMEPAGE="http://www.lesbonscomptes.com/recoll/"
SRC_URI="http://www.lesbonscomptes.com/recoll/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

INDEX_HELPERS="chm djvu dvi exif postscript ics info lyx msdoc msppt msxls pdf rtf sound tex wordperfect xml"
IUSE="+spell +inotify +qt4 +session camelcase xattr fam ${INDEX_HELPERS}"

DEPEND="
	virtual/libiconv
	>=dev-libs/xapian-1.0.12
	sys-libs/zlib
	spell? ( app-text/aspell )
	!inotify? ( fam? ( virtual/fam ) )
	qt4? (
		dev-qt/qtcore:4[qt3support]
		dev-qt/qtwebkit:4
		)
	session? (
		inotify? ( x11-libs/libX11 x11-libs/libSM x11-libs/libICE )
		!inotify? ( fam? ( x11-libs/libX11 x11-libs/libSM x11-libs/libICE ) )
	)
"

RDEPEND="
	${DEPEND}
	app-arch/unzip
	sys-apps/sed
	virtual/awk
	pdf? ( app-text/poppler )
	postscript? ( app-text/pstotext )
	msdoc? ( app-text/antiword )
	msxls? ( app-text/catdoc )
	msppt? ( app-text/catdoc )
	wordperfect? ( app-text/libwpd:0.9 )
	rtf? ( app-text/unrtf )
	tex? ( dev-tex/detex )
	dvi? ( virtual/tex-base )
	djvu? ( >=app-text/djvu-3.5.15 )
	exif? ( media-libs/exiftool )
	chm? ( dev-python/pychm )
	ics? ( dev-python/icalendar )
	lyx? ( app-office/lyx )
	sound? ( media-libs/mutagen )
	xml? ( dev-libs/libxslt )
	info? ( sys-apps/texinfo )
	"

REQUIRED_USE="^^ ( fam inotify ) session? ( || ( fam inotify ) )"

pkg_pretend() {
	if use inotify; then
		CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	local i at_least_one_helper

	at_least_one_helper=0
	for i in $INDEX_HELPERS; do
		if use $i; then
			at_least_one_helper=1
			break
		fi
	done
	if [[ $at_least_one_helper -eq 0 ]]; then
		ewarn
		ewarn "You did not enable any of the optional file format flags."
		ewarn "Recoll can read some file formats natively, but many of them"
		ewarn "are optional since they require external helpers."
		ewarn
	fi
}

src_prepare() {
	# remember configure.ac is b0rked. Fix it before using eautoreconf in the
	# future
	# eautoreconf

	# do not strip binaries
	sed -i -e "/STRIP/d" "${S}"/${PN}install.in \
		|| die "Failed to fix the installation script"
	# Drop all the QMAKE lines. We will do it ourselves
	sed -i -e "/QMAKE/d" Makefile.in || die
}

src_configure() {
	local qtconf

	use qt4 && qtconf="QMAKEPATH=/usr/bin/qmake"

	econf \
		$(use_with spell aspell) \
		$(use_enable xattr) \
		$(use_with inotify) \
		$(use_enable qt4 qtgui) \
		$(use_enable camelcase) \
		$(use_with fam) \
		$(use_with inotify) \
		$(use_enable session x11mon) \
		${qtconf}
	if use qt4; then
		cd qtgui && eqmake4 ${PN}.pro && cd ..
	fi
}

src_compile() {
	# Do not let upstream people decide on our behalf
	sed -i "s:ar ru:$(tc-getAR) ru:" lib/Makefile || die

	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
}

src_install() {
	# You probably wonder why I did not fix recollinstall in src_prepare.
	# --prefix requires an absolute path but recollinstall requires prefix
	# to be actually 'usr' because double // makes portage sad. And no, I am not
	# gonna ask upstream to fix the build system
	sed -i -e "/PREFIX/s:/usr:usr:" "${S}"/${PN}install || die
	sed -i -e "/prefix/s:/usr:usr:" "${S}"/Makefile || die

	emake DESTDIR="${D%/}" install
	dodoc ChangeLog README
	mv "${D}/usr/share/${PN}/doc" "${D}/usr/share/doc/${PF}/html"
	dosym /usr/share/doc/${PF}/html /usr/share/${PN}/doc
}

pkg_postinst() {
	elog
	elog "Default configuration files located at"
	elog "/usr/share/${PN}/examples. Either edit these files to match"
	elog "your needs or copy them to ~/.recoll/ and edit these files"
	elog "instead."
	elog
	if use xattr; then
		elog "Use flag \"xattr\" enables support for fetching field values"
		elog "from extended file attributes. You will also need to set up a"
		elog "map from the attributes names to the Recoll field names"
		elog "(see comment at the end of the fields configuration file."
	fi
}
