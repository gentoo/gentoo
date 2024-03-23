# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DOCS_BUILDER="doxygen"
# File is hardcoded to be run from ../ so we use this instead of DOCS_DIR
DOCS_CONFIG_NAME="doc/Doxyfile"

inherit autotools docs python-single-r1 perl-functions

JSMN_COMMIT="85695f3d5903b1cd5b4030efe50db3b4f5f3c928"

DESCRIPTION="C library to handle DWG files"
HOMEPAGE="https://www.gnu.org/software/libredwg/ https://github.com/LibreDWG/libredwg"
SRC_URI="
	https://github.com/LibreDWG/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/${JSMN_COMMIT}.tar.gz -> ${PN}-${JSMN_COMMIT}.tar.gz
"

LICENSE="GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"

# https://github.com/LibreDWG/libredwg/issues/342
RESTRICT="test"

IUSE="debug python perl static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	perl? ( dev-lang/perl )
	dev-libs/libpcre2
	dev-libs/pslib
"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	perl? ( dev-lang/swig )
"
BDEPEND="|| (
	sys-devel/gcc[sanitize]
	sys-libs/compiler-rt-sanitizers[asan(-)]
	)
	dev-vcs/git
"

src_unpack() {
	# Build system really wants jsmn to be here
	default
	rm -r "${S}/jsmn" || die
	mv "${WORKDIR}/jsmn-${JSMN_COMMIT}" "${S}/jsmn" || die
}

src_prepare() {
	default
	# Fix variable references itself error, fails in src_install otherwise.
	sed -i -e 's/TEXINPUTS="$(TEXINPUTS)$(PATH_SEPARATOR)$(TEXINFO_TEX_DIR)"/TEXINPUTS="$(PATH_SEPARATOR)$(TEXINFO_TEX_DIR)"/g' doc/Makefile.am || die
	# https://github.com/LibreDWG/libredwg/issues/404
	# Workaround: release tarball does not include dwg2ps.1.
	# Upstream autotools stuff has to be run in git repo
	git init -q || die
	git config --global user.email "larry@gentoo.org" || die
	git config --global user.name "Larry the Cow" || die
	git add . || die
	git commit -qm 'init' || die
	git tag ${PV} || die
	eautoreconf
}

src_configure() {
	perl_set_version
	local myconf=(
		--enable-write
		--enable-dxf
		--enable-json
		--disable-gcov
		--disable-werror
		$(use_enable !debug release)
		$(use_enable debug trace)
		$(use_enable debug)
		$(use_enable static-libs static)
		$(use_enable python python "${EPYTHON}")
		$(usex perl "--with-perl-install=vendor" "--with-perl-install=no")
	)

	if use python || use perl; then
		myconf+=( --enable-bindings )
	else
		myconf+=( --disable-bindings )
	fi

	econf ${myconf[@]}
}

src_compile() {
	perl_set_version
	emake
	docs_compile
}

src_install() {
	perl_set_version
	default
	use python && python_optimize
	# remove .la files if static-libs disabled
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
