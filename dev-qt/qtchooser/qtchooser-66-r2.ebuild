# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils toolchain-funcs

DESCRIPTION="Tool to quickly switch between multiple Qt installations"
HOMEPAGE="https://code.qt.io/cgit/qtsdk/qtchooser.git/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://code.qt.io/qtsdk/qtchooser.git"
	inherit git-r3
else
	SRC_URI="https://download.qt.io/official_releases/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="|| ( LGPL-2.1 GPL-3 )"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? (
		dev-qt/qtcore:5
		dev-qt/qttest:5
	)"
RDEPEND="!<dev-qt/qtcore-5.15.3:5"

PATCHES=( "${FILESDIR}/${PN}-66-qt-5.15.3-compat.patch" )

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

	# install configuration file
	cat > "${T}/qt5-${CHOST}.conf" <<-_EOF_ || die
		$(qt5_get_bindir)
		$(qt5_get_libdir)
	_EOF_

	(
		insinto /etc/xdg/qtchooser
		doins "${T}/qt5-${CHOST}.conf"
	)

	# convenience symlinks
	dosym qt5-"${CHOST}".conf /etc/xdg/qtchooser/5.conf
	dosym qt5-"${CHOST}".conf /etc/xdg/qtchooser/qt5.conf
	dosym qt5.conf /etc/xdg/qtchooser/default.conf

	# TODO: bash and zsh completion
	# newbashcomp scripts/${PN}.bash ${PN}
}
