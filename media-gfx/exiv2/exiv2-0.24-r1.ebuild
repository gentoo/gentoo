# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multilib toolchain-funcs python-any-r1 autotools-multilib

DESCRIPTION="EXIF and IPTC metadata C++ library and command line utility"
HOMEPAGE="http://www.exiv2.org/"
SRC_URI="http://www.exiv2.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/13"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE_LINGUAS="de es fi fr pl ru sk"
IUSE="contrib doc examples nls xmp zlib static-libs $(printf 'linguas_%s ' ${IUSE_LINGUAS})"

RDEPEND="
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	xmp? ( >=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	contrib? ( >=dev-libs/boost-1.44 )
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

PATCHES=( "${FILESDIR}/${P}-CVE-2014-9449.patch" )

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# convert docs to UTF-8
	local i
	for i in doc/cmd.txt; do
		einfo "Converting "${i}" to UTF-8"
		iconv -f LATIN1 -t UTF-8 "${i}" > "${i}~" && mv -f "${i}~" "${i}" || rm -f "${i}~"
	done

	if use doc; then
		einfo "Updating doxygen config"
		doxygen 2>&1 >/dev/null -u config/Doxyfile
	fi

	if use contrib; then
		# create build environment for contrib
		ln -snf ../../src contrib/organize/exiv2
		sed -i -e 's:/usr/local/include/.*:'"${EPREFIX}"'/usr/include:g' \
			-e 's:/usr/local/lib/lib:-l:g' -e 's:-gcc..-mt-._..\.a::g' \
			contrib/organize/boost.mk || die
	fi

	epatch "${FILESDIR}/${PN}-0.24-python3.patch"

	# set locale to safe value for the sed commands (bug #382731)
	sed -i -r "s,(\s+)sed\s,\1LC_ALL="C" sed ,g" src/Makefile || die

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable xmp)
		$(use_enable static-libs static)
	)

	# plain 'use_with' fails
	use zlib || myeconfargs+=( --without-zlib )

	# Bug #78720. amd64/gcc-3.4/-fvisibility* fail.
	if [[ ${ABI} == amd64 && $(gcc-major-version) -lt 4 ]]; then
		myeconfargs+=( --disable-visibility )
	fi

	autotools-utils_src_configure
}

multilib_src_compile() {
	# Needed for Solaris because /bin/sh is not a bash, bug #245647
	sed -i -e "s:/bin/sh:${EPREFIX}/bin/sh:" src/Makefile || die "sed failed"
	emake

	if multilib_is_native_abi; then
		if use contrib; then
			emake -C contrib/organize \
				LDFLAGS="\$(BOOST_LIBS) -L../../src -lexiv2 ${LDFLAGS}" \
				CPPFLAGS="${CPPFLAGS} -I\$(BOOST_INC_DIR) -I. -DEXV_HAVE_STDINT_H"
		fi

		if use doc; then
			emake samples
			emake doc
		fi
	fi
}

multilib_src_install() {
	autotools-utils_src_install

	if multilib_is_native_abi; then
		if use contrib; then
			emake DESTDIR="${D}" -C contrib/organize install
		fi

		use doc && dohtml -r doc/html/.
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	use xmp && dodoc doc/{COPYING-XMPSDK,README-XMP,cmdxmp.txt}
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/examples
		doins samples/*.cpp
	fi
}
