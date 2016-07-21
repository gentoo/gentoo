# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

USE_PHP="php5-4 php5-5 php5-6"
PHP_EXT_NAME="geos"
PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_SKIP_PHPIZE="yes"

inherit php-ext-source-r2 autotools eutils python-single-r1 python-utils-r1

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://trac.osgeo.org/geos/"
SRC_URI="http://download.osgeo.org/geos/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc php python ruby static-libs"

RDEPEND="
	ruby? ( dev-lang/ruby:* )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	php? (
		dev-lang/swig
		app-admin/chrpath
	)
	python? ( dev-lang/swig ${PYTHON_DEPS} )
	ruby? ( dev-lang/swig )
"

PATCHES=(
	"${FILESDIR}"/3.4.2-solaris-isnan.patch
	"${FILESDIR}"/${P}-phpconfig-path.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

# Call default here to override the php-ext-source-r2_src_unpack
src_unpack() {
	default
}

src_prepare() {
	epatch "${PATCHES[@]}"
	eautoreconf
	echo "#!${EPREFIX}/bin/bash" > py-compile
	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			cp -a "${S}" "${WORKDIR}/${php_slot}" || die
		done
	fi
}

src_configure() {
	# bug 576436 - does not support PHP-7.0
	local PHP_CONFIG
	local php_libdir="${EROOT}usr/$(get_libdir)"

	econf \
		$(use_enable python) \
		$(use_enable ruby) \
		--disable-php \
		$(use_enable static-libs static)

	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			PHP_CONFIG="${php_libdir}/${php_slot}/bin/php-config"
			[[ -e "${PHP_CONFIG}" ]] && export PHP_CONFIG
			pushd "${WORKDIR}/${php_slot}" > /dev/null || die
			econf \
				--disable-python \
				--disable-ruby \
				--enable-php \
				--disable-static
			popd > /dev/null || die
		done
	fi
}

src_compile() {
	emake
	if use php; then
		local php_slot
		for php_slot in $(php_get_slots); do
			pushd "${WORKDIR}/${php_slot}/php" > /dev/null || die
			rm -r ../capi || die
			ln -sfr "${S}/capi" ../capi
			emake
			popd > /dev/null || die
		done
	fi

	use doc && emake -C "${S}/doc" doxygen-html
}

src_install() {
	emake DESTDIR="${D}" install

	use doc && dohtml -r doc/doxygen_docs/html/*
	use python && python_optimize "${D}$(python_get_sitedir)"/geos/

	if use php; then
		local php_slot
		local libpath
		local php_libdir="${EROOT}usr/$(get_libdir)"

		for php_slot in $(php_get_slots); do
			pushd "${WORKDIR}/${php_slot}/php" > /dev/null || die
			emake DESTDIR="${D}" install
			popd > /dev/null || die
			# The libpath will vary by slot as the extension-dir is tied to the API date
			libpath="lib/extensions/$(${php_libdir}/${php_slot}/bin/php-config --extension-dir | grep -o '[^/]*$')/geos.so"
			local lib="${D}/usr/$(get_libdir)/${php_slot}/${libpath}"
			if [[ -e "${lib}" ]]; then
				chrpath -d ${lib} || die "Failed cleaning RPATH on '${lib}'"
			fi
		done
	fi

	prune_libtool_files
}
