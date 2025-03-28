# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUBY_OPTIONAL=no
USE_RUBY="ruby32"
# note: define maximally ONE implementation here

PYTHON_COMPAT=( python3_{11,12,13} )

inherit toolchain-funcs python-single-r1 ruby-ng

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/klayoutmatthias/${PN}.git"
	inherit git-r3
	EGIT_CHECKOUT_DIR=${WORKDIR}/all/${P}
else
	SRC_URI="https://www.klayout.org/downloads/source/${P}.tar.gz https://dev.gentoo.org/~dilfridge/distfiles/${P}-qt6.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Viewer and editor for GDS and OASIS integrated circuit layouts"
HOMEPAGE="https://www.klayout.de/"
LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	dev-qt/qtbase:6[gui,network,sql,ssl,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[designer]
	dev-libs/libgit2:=
	sys-libs/zlib
	${PYTHON_DEPS}
	$(ruby_implementations_depend)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/all/qt6-patches/klayout-0.29.11-0001-Fixing-issue-1987-build-failure-against-Qt6.8.patch
	"${WORKDIR}"/all/qt6-patches/klayout-0.29.11-0002-WIP-more-fixes-for-Qt-6.8-compatibility.patch
	"${WORKDIR}"/all/qt6-patches/klayout-0.29.11-0003-More-patches.patch
)

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
		-qmake "$EPREFIX/usr/$(get_libdir)/qt6/bin/qmake" \
		-ruby "${RUBY}" \
		-python "${PYTHON}" \
		-build . \
		-bin "${T}/bin" \
		-rpath "$EPREFIX/usr/$(get_libdir)/klayout" \
		-option "${MAKEOPTS}" \
		-with-qtbinding \
		-without-64bit-coord || die "Configuration failed"
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
