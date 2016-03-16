# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils cmake-multilib python-any-r1

DESCRIPTION="EXIF, IPTC and XMP metadata C++ library and command line utility"
HOMEPAGE="http://www.exiv2.org/"
SRC_URI="http://www.exiv2.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/14"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
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
		virtual/pkgconfig
		media-gfx/graphviz
		${PYTHON_DEPS}
	)
	nls? ( sys-devel/gettext )
"

DOCS=( README doc/ChangeLog doc/cmd.txt )

PATCHES=(
	"${FILESDIR}/${PN}-0.25-fix-install-dirs.patch"
	"${FILESDIR}/${PN}-0.25-fix-without-zlib.patch"
	"${FILESDIR}/${PN}-0.25-hide-symbols.patch"
	"${FILESDIR}/${PN}-0.25-fvisibility-hidden.patch"
	# TODO: Take to upstream
	"${FILESDIR}/${PN}-0.25-fix-docs.patch"
	"${FILESDIR}/${PN}-0.25-tools-optional.patch"
)

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	rm -r msvc* build || die "Failed to remove msvc dirs"

	if [[ ${PV} != *9999 ]] ; then
		if [[ -d po ]] ; then
			pushd po > /dev/null || die
			for lang in *.po; do
				if ! has ${lang%.po} ${LINGUAS} ; then
					rm -rf ${lang} || die
				fi
			done
			popd > /dev/null || die
		else
			die "Failed to prepare LINGUAS - po directory moved?"
		fi
	fi

	# convert docs to UTF-8
	local i
	for i in doc/cmd.txt; do
		einfo "Converting "${i}" to UTF-8"
		iconv -f LATIN1 -t UTF-8 "${i}" > "${i}.tmp" || die
		mv -f "${i}.tmp" "${i}" || die
	done

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
		-DEXIV2_ENABLE_CURL=$(usex webready)
		-DEXIV2_ENABLE_NLS=$(usex nls)
		-DEXIV2_ENABLE_PNG=$(usex png)
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
	einstalldocs
	prune_libtool_files --all

	use xmp && dodoc doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt}
	use doc && dodoc -r "${S}"/doc/html

	if use examples; then
		docinto examples
		dodoc samples/*.cpp
	fi
}
