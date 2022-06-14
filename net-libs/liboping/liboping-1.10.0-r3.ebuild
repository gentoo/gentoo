# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps perl-module

DESCRIPTION="Protocol independent ANSI-C ping library and command line utility"
HOMEPAGE="
	https://noping.cc/
	https://github.com/octo/liboping
"
SRC_URI="https://noping.cc/files/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/0.3"
KEYWORDS="~alpha amd64 arm ~arm64 x86"
IUSE="+filecaps ncurses perl"

DEPEND="ncurses? ( sys-libs/ncurses:0= )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.0-no-werror.patch"
	"${FILESDIR}/${PN}-1.6.2-nouidmagic.patch"
	"${FILESDIR}/${PN}-1.10.0-gcc8-fix.patch"
	"${FILESDIR}/${PN}-1.10.0-do-not-quit-when-ping_send-fail.patch"
	"${FILESDIR}/${PN}-1.10.0-report-right-error-msg-when-select-fails.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	myeconfargs=(
		$(use_with ncurses)
		$(use_with perl perl-bindings INSTALLDIRS=vendor)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	if use perl; then
		pushd bindings/perl || die
		perl-module_src_test
		popd || die
	fi
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	if use filecaps; then
		local _caps_str="CAP_NET_RAW"
		_files=( "${EROOT}/usr/bin/oping")

		if use ncurses; then
			_files+=( "${EROOT}/usr/bin/noping")
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
