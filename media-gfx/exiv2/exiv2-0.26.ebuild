# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-multilib python-any-r1

DESCRIPTION="EXIF, IPTC and XMP metadata C++ library and command line utility"
HOMEPAGE="http://www.exiv2.org/"
SRC_URI="http://www.exiv2.org/builds/${P}-trunk.tar.gz"

LICENSE="GPL-2"
SLOT="0/26"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE_LINGUAS="bs de es fi fr gl ms pl pt ru sk sv ug uk vi"
IUSE="doc examples nls png webready xmp $(printf 'linguas_%s ' ${IUSE_LINGUAS})"

RDEPEND="
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	png? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	webready? (
		net-libs/libssh[${MULTILIB_USEDEP}]
		net-misc/curl[${MULTILIB_USEDEP}]
	)
	xmp? ( >=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-libs/libxslt
		media-gfx/graphviz
		virtual/pkgconfig
		${PYTHON_DEPS}
	)
	nls? ( sys-devel/gettext )
"

DOCS=( README doc/ChangeLog doc/cmd.txt )

PATCHES=(
	"${FILESDIR}"/${P}-cmake{1,2,3,4,5,6,7}.patch
	"${FILESDIR}"/${P}-CVE-2017-9239.patch
	# TODO: Take to upstream
	"${FILESDIR}"/${P}-fix-docs.patch
	"${FILESDIR}"/${P}-tools-optional.patch
)

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_unpack() {
	# FIXME @upstream: MacOS cruft is breaking the buildsystem, so don't let it in...
	tar -C "${WORKDIR}" --exclude=.* -xpf "${DISTDIR}/${A}" --gz 2> /dev/null ||
		elog "${my_tar}: tar extract command failed at least partially - continuing"
	mv "${PN}-trunk" "${S}" || die "Failed to create source dir ${S}"
}

src_prepare() {
	if [[ ${PV} != *9999 ]] ; then
		if [[ -d po ]] ; then
			pushd po > /dev/null || die
			local lang
			for lang in *.po; do
				if [[ -e ${lang} ]] && ! has ${lang/.po/} ${LINGUAS} ; then
					case ${lang} in
						CMakeLists.txt | \
						${PN}.pot)      ;;
						*) rm -r ${lang} || die ;;
					esac
				fi
			done
			popd > /dev/null || die
		else
			die "Failed to prepare LINGUAS - po directory moved?"
		fi
	fi

	# FIXME @upstream:
	einfo "Converting doc/cmd.txt to UTF-8"
	iconv -f LATIN1 -t UTF-8 doc/cmd.txt > doc/cmd.txt.tmp || die
	mv -f doc/cmd.txt.tmp doc/cmd.txt || die

	if use doc; then
		einfo "Updating doxygen config"
		doxygen &>/dev/null -u config/Doxyfile || die
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DEXIV2_ENABLE_BUILD_PO=YES
		-DEXIV2_ENABLE_BUILD_SAMPLES=NO
		-DEXIV2_ENABLE_NLS=$(usex nls)
		-DEXIV2_ENABLE_PNG=$(usex png)
		-DEXIV2_ENABLE_CURL=$(usex webready)
		-DEXIV2_ENABLE_SSH=$(usex webready)
		-DEXIV2_ENABLE_WEBREADY=$(usex webready)
		-DEXIV2_ENABLE_XMP=$(usex xmp)
		-DEXIV2_ENABLE_LIBXMP=NO
		$(multilib_is_native_abi || \
			echo -DEXIV2_ENABLE_TOOLS=NO)
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	if multilib_is_native_abi; then
		use doc && emake -j1 doc
	fi
}

multilib_src_install_all() {
	use xmp && DOCS+=( doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt} )
	use doc && HTML_DOCS=( "${S}"/doc/html/. )

	einstalldocs
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc samples/*.cpp
	fi
}
