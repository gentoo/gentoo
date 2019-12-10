# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils toolchain-funcs

DESCRIPTION="Tool to quickly switch between multiple Qt installations"
HOMEPAGE="https://code.qt.io/cgit/qtsdk/qtchooser.git/"
SRC_URI="http://download.qt.io/official_releases/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		dev-qt/qtcore:5
		dev-qt/qttest:5
	)"
RDEPEND=""

qtchooser_make() {
	emake \
		CXX="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		"$@"
}

src_compile() {
	qtchooser_make
}

src_test() {
	pushd tests/auto >/dev/null || die
	eqmake5
	popd >/dev/null || die

	qtchooser_make check
}

src_install() {
	qtchooser_make INSTALL_ROOT="${D}" install

	keepdir /etc/xdg/qtchooser

	# TODO: bash and zsh completion
	# newbashcomp scripts/${PN}.bash ${PN}
}
