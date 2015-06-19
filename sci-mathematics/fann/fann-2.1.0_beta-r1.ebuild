# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/fann/fann-2.1.0_beta-r1.ebuild,v 1.3 2012/05/08 18:18:55 bicatali Exp $

EAPI=2

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit eutils python autotools

MY_P=${P/_/}

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="http://leenissen.dk/fann/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc python static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	app-arch/unzip"

S="${WORKDIR}/${P/_beta/}"

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-python.patch \
		"${FILESDIR}"/${P}-benchmark.patch \
		"${FILESDIR}"/${P}-examples.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-valist.patch \
		"${FILESDIR}"/${P}-sizecheck.patch
	eautoreconf
	use python && python_copy_sources python
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake || die "emake failed"
	compilation() {
		emake PYTHON_VERSION="$(python_get_version)" || die "emake python failed"
	}
	use python && python_execute_function -s --source-dir python compilation
}

src_test() {
	cd "${S}"/examples
	emake CFLAGS="${CFLAGS} -I../src/include -L../src/.libs" \
		|| die "emake examples failed"
	LD_LIBRARY_PATH="../src/.libs" emake runtest || die "tests failed"
	emake clean
	testing() {
		emake test || die "failed tests for python wrappers"
	}
	 use python && python_execute_function -s --source-dir python testing
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die

	if use doc; then
		dodoc doc/*.txt
		insinto /usr/share/doc/${PF}
		doins doc/fann_en.pdf || die "failed to install reference manual"
		doins -r examples || die "failed to install examples"
		doins -r benchmarks || die "failed to install benchmarks"
	fi

	installation() {
		emake install ROOT="${D}" || die "failed to install python wrappers"
		if use doc; then
			insinto /usr/share/doc/${PF}/examples/python
			doins -r examples || die "failed to install python examples"
		fi
	}
	use python && python_execute_function -s --source-dir python installation
}

pkg_postinst() {
	use python && python_mod_optimize py${PN}
}

pkg_postrm() {
	use python && python_mod_cleanup py${PN}
}
