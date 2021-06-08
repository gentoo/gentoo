# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUBY_OPTIONAL=no
USE_RUBY="ruby26"
# note: define maximally ONE implementation here

PYTHON_COMPAT=( python3_{7,8,9} )

inherit toolchain-funcs python-single-r1 ruby-ng

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/klayoutmatthias/${PN}.git"
	inherit git-r3
	EGIT_CHECKOUT_DIR=${WORKDIR}/all/${P}
else
	SRC_URI="https://www.klayout.org/downloads/source/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Viewer and editor for GDS and OASIS integrated circuit layouts"
HOMEPAGE="https://www.klayout.de/"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	sys-libs/zlib
	${PYTHON_DEPS}
	$(ruby_implementations_depend)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
	ruby-ng_pkg_setup
}

each_ruby_configure() {
	tc-export CC CXX AR LD RANLIB
	export CFLAGS CXXFLAGS
	./build.sh \
		-expert \
		-dry-run \
		-qmake "/usr/$(get_libdir)/qt5/bin/qmake" \
		-ruby "${RUBY}" \
		-python "${PYTHON}" \
		-build . \
		-bin "${T}/bin" \
		-rpath "/usr/$(get_libdir)/klayout" \
		-option "${MAKEOPTS}" \
		-with-qtbinding \
		-without-64bit-coord \
		-qt5 || die "Configuration failed"
}

each_ruby_compile() {
	emake all
}

each_ruby_install() {
	emake install

	cd "${T}/bin" || die

	dodir "/usr/$(get_libdir)/klayout"
	mv lib* lay_plugins db_plugins "${ED}/usr/$(get_libdir)/klayout/" || die

	mkdir -p "${D}/$(python_get_sitedir)" || die
	mv pymod/* "${D}/$(python_get_sitedir)/" || die
	rmdir pymod || die

	dobin *

	python_optimize
}
