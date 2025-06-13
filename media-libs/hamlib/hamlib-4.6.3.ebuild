# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
MY_P=${P/_rc2/~rc2}

inherit autotools flag-o-matic python-single-r1

DESCRIPTION="Ham radio backend rig control libraries"
HOMEPAGE="https://www.hamlib.github.io"
SRC_URI="https://downloads.sourceforge.net/hamlib/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0/4.2"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="doc perl python tcl"

RESTRICT="test"

RDEPEND="
	=virtual/libusb-0*
	dev-libs/libxml2:=
	sys-libs/readline:0=
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )"

DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-lang/swig
	dev-build/autoconf-archive
	>=dev-build/libtool-2.2
	doc? ( app-text/doxygen
		dev-util/source-highlight )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=(AUTHORS NEWS PLAN README README.betatester README.developer)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Correct install target to whatever INSTALLDIRS says and use vendor
	# installdirs everywhere (bug #611550)
	sed -i -e "s#install_site#install#"	\
	-e 's#MAKEFILE="Hamlib-pl.mk"#MAKEFILE="Hamlib-pl.mk" INSTALLDIRS=vendor#' \
	bindings/Makefile.am || die "sed failed patching for perl"

	# make building of documentation compatible with autotools-utils
	sed -i -e "s/doc:/html:/g" doc/Makefile.am || die "sed failed"

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/926839
	# https://github.com/Hamlib/Hamlib/issues/1524
	filter-lto

	econf \
		--libdir=/usr/$(get_libdir)/hamlib \
		--disable-static \
		--with-xml-support \
		$(use_with perl perl-binding) \
		$(use_with python python-binding) \
		$(use_with tcl tcl-binding)
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	emake DESTDIR="${D}" install

	use python && python_optimize

	use doc && HTML_DOCS=( doc/html/ )
	einstalldocs

	insinto /usr/$(get_libdir)/pkgconfig
	doins hamlib.pc

	echo "LDPATH=/usr/$(get_libdir)/hamlib" > "${T}"/73hamlib
	doenvd "${T}"/73hamlib

	find "${ED}" -name '*.la' -delete || die
}
