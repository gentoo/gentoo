# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools fcaps perl-module

DESCRIPTION="Protocol independent ANSI-C ping library and command line utility"
HOMEPAGE="https://noping.cc/"
SRC_URI="https://noping.cc/files/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0/0.2"
KEYWORDS="amd64 arm x86"
IUSE="+filecaps ncurses perl"

DEPEND="ncurses? ( sys-libs/ncurses:0= )"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}/${PN}-1.6.2-nouidmagic.patch"
	"${FILESDIR}/${PN}-1.8.0-remove-ncurses-automagic.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_with perl perl-bindings INSTALLDIRS=vendor) \
		$(use_with ncurses)
}

src_test() {
	if use perl; then
		pushd bindings/perl >/dev/null || die
		perl-module_src_test
		popd >/dev/null || die
	fi
}

src_install() {
	default

	find "${ED}"usr/lib* -name '*.la' -o -name '*.a' -delete || die
}

pkg_postinst() {
	if use filecaps; then
		local _caps_str="CAP_NET_RAW"
		_files=( "${EROOT%/}/usr/bin/oping")

		if use ncurses; then
			_files+=( "${EROOT%/}/usr/bin/noping")
		fi

		fcaps "${_caps_str}" "${_files[@]}"

		elog "Capabilities for"
		elog ""

		local _file=
		for _file in "${_files[@]}"; do
			elog "  ${_file}"
		done

		elog ""
		elog "set to ${_caps_str}+EP due to set 'filecaps' USE flag."
		elog
	fi
}
