# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtbase"
inherit linux-info qt5-build

DESCRIPTION="Cross-platform application development framework"
SLOT=5/$(ver_cut 1-3)

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~ppc ppc64 ~sparc x86"
fi

IUSE="icu old-kernel systemd"

DEPEND="
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2[pcre16,unicode]
	sys-libs/zlib:=
	icu? ( dev-libs/icu:= )
	!icu? ( virtual/libiconv )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}
	!<dev-qt/qtcore-4.8.7-r4:4
"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
	src/tools/qlalr
	doc
)

QT5_GENTOO_PRIVATE_CONFIG=(
	!:network
	!:sql
	!:testlib
	!:xml
)

PATCHES=(
	"${FILESDIR}/${PN}-5.14.1-cmake-macro-backward-compat.patch" # bug 703306
	"${FILESDIR}/${P}-QLibrary-deadlock.patch" # QTBUG-83207
)

pkg_pretend() {
	use kernel_linux || return
	get_running_version
	if kernel_is -lt 3 17 && ! use old-kernel; then
		ewarn "The running kernel is older than 3.17. USE=old-kernel is needed for"
		ewarn "dev-qt/qtcore to function on this kernel properly. See Bug #669994."
	fi
}

src_prepare() {
	# don't add -O3 to CXXFLAGS, bug 549140
	sed -i -e '/CONFIG\s*+=/s/optimize_full//' src/corelib/corelib.pro || die

	# fix missing qt_version_tag symbol w/ LTO, bug 674382
	sed -i -e 's/^gcc:ltcg/gcc/' src/corelib/global/global.pri || die

	qt5-build_src_prepare
}

src_configure() {
	local myconf=(
		-no-feature-statx	# bug 672856
		$(qt_use icu)
		$(qt_use !icu iconv)
		$(qt_use systemd journald)
	)
	use old-kernel && myconf+=(
		-no-feature-renameat2 # needs Linux 3.16, bug 669994
		-no-feature-getentropy # needs Linux 3.17, bug 669994
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install

	local flags=(
		DBUS FREETYPE IMAGEFORMAT_JPEG IMAGEFORMAT_PNG
		OPENGL OPENSSL SSL WIDGETS
	)

	for flag in ${flags[@]}; do
		cat >> "${D}"/${QT5_HEADERDIR}/QtCore/qconfig.h <<- _EOF_ || die

			#if defined(QT_NO_${flag}) && defined(QT_${flag})
			# undef QT_NO_${flag}
			#elif !defined(QT_NO_${flag}) && !defined(QT_${flag})
			# define QT_NO_${flag}
			#endif
		_EOF_
	done
}
