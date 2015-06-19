# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel/openbabel-2.2.3.ebuild,v 1.16 2012/04/26 15:46:14 jlec Exp $

EAPI="3"

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="openbabel.py pybel.py"

inherit eutils distutils

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc python swig"

RDEPEND="
	dev-libs/libxml2:2
	!sci-chemistry/babel
	!sci-chemistry/openbabel-perl
	!sci-chemistry/openbabel-python
	sys-libs/zlib"

DEPEND="${RDEPEND}
	dev-lang/perl
	>=dev-libs/boost-1.35.0
	python? ( swig? ( >=dev-lang/swig-1.3.38 ) )
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.2.0-doxyfile.patch"
	if use python; then
		cd "${S}/scripts/python"
		distutils_src_prepare
	fi
}

src_configure() {
	local swigconf=""
	if use swig; then
		swigconf="--enable-maintainer-mode"
	fi
	econf ${swigconf}
}

src_compile() {
	emake || die "emake failed"
	if use doc ; then
		emake docs || die "make docs failed"
	fi
	if use swig; then
		emake scripts/python/openbabel_python.cpp \
			|| die "Failed to make SWIG python bindings"
	fi
	if use python; then
		cd "${S}/scripts/python"
		distutils_src_compile
	fi
}

src_test() {
	emake check || die "make check failed"
}

src_install() {
	dodoc AUTHORS ChangeLog NEWS README THANKS doc/{*.inc,README*,*.inc,*.mol2} || die
	dohtml doc/{*.html,*.png} || die
	if use doc ; then
		insinto /usr/share/doc/${PF}/API/html
		doins doc/API/html/* || die
	fi

	emake DESTDIR="${D}" install || die "make install failed"
	# Now to install the Python bindings if necessary
	if use python; then
		cd "${S}/scripts/python"
		distutils_src_install
		if use doc; then
			docinto python
			dodoc README || die
			docinto python/html
			dodoc *.html || die
		fi
	fi
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
