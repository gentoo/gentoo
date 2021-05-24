# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DOCS_BUILDER="doxygen"
# File is hardcoded to be run from ../ so we use this instead of DOCS_DIR
DOCS_CONFIG_NAME="doc/Doxyfile"

inherit docs python-single-r1 perl-functions

DESCRIPTION="C library to handle DWG files"
HOMEPAGE="https://www.gnu.org/software/libredwg/"
SRC_URI="https://github.com/LibreDWG/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
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

src_configure() {
	perl_set_version
	local myconf=(
		--enable-write
		--enable-dxf
		--enable-json
		--disable-gcov
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

	# Fix variable references itself error, fails in src_install otherwise.
	# Can't put this in src_prepare and use eautoreconf because eautoreconf
	# only works inside a git repository for this package.
	sed -i -e 's/TEXINPUTS = "$(TEXINPUTS)$(PATH_SEPARATOR)$(TEXINFO_TEX_DIR)"/TEXINPUTS = "$(PATH_SEPARATOR)$(TEXINFO_TEX_DIR)"/g' doc/Makefile || die
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
	use perl && perl_domodule bindings/perl/LibreDWG.pm
}
