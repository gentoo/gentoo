# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
MY_P=${P/_rc2/~rc2}

inherit autotools python-single-r1

DESCRIPTION="Ham radio backend rig control libraries"
HOMEPAGE="http://www.hamlib.org"
SRC_URI="mirror://sourceforge/hamlib/${MY_P}.tar.gz"

LICENSE="LGPL-2 GPL-2"
SLOT="0/4.2"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"
IUSE="doc perl python tcl"

RESTRICT="test"

RDEPEND="
	=virtual/libusb-0*
	dev-libs/libxml2
	sys-libs/readline:0=
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )"

DEPEND=" ${RDEPEND}
	virtual/pkgconfig
	dev-lang/swig
	>=sys-devel/libtool-2.2
	doc? ( app-doc/doxygen
		dev-util/source-highlight )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=(AUTHORS NEWS PLAN README README.betatester README.developer)

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# fix hardcoded libdir paths
	sed -i -e "s#fix}/lib#fix}/$(get_libdir)/hamlib#" \
		-e "s#fix}/include#fix}/include/hamlib#" \
		hamlib.pc.in || die "sed failed"

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
