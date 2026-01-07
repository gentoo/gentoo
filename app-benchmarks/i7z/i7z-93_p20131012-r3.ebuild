# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils toolchain-funcs

COMMIT="5023138d7c35c4667c938b853e5ea89737334e92"
DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="https://github.com/ajaiantilal/i7z"
SRC_URI="https://github.com/ajaiantilal/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 x86"

IUSE="policykit qt6"

RDEPEND="
	sys-libs/ncurses:0=
	qt6? (
		policykit? ( sys-auth/polkit )
		dev-qt/qtbase:6[gui,widgets]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/i7z-0.27.2-ncurses.patch
	"${FILESDIR}"/qt5.patch
	"${FILESDIR}"/gcc5.patch

	# From Debian
	"${FILESDIR}"/fix-insecure-tempfile.patch
	"${FILESDIR}"/fix_cpuid_asm.patch
	"${FILESDIR}"/hyphen-used-as-minus-sign.patch
	"${FILESDIR}"/install-i7z_rw_registers.patch
	"${FILESDIR}"/use_stdbool.patch
	"${FILESDIR}"/nehalem.patch
	"${FILESDIR}"/gcc-10.patch
	"${FILESDIR}"/typos.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	cd GUI || die
	use qt6 && eqmake6 ${PN}_GUI.pro
}

src_compile() {
	default

	if use qt6; then
		emake -C GUI clean
		emake -C GUI
	fi
}

src_install() {
	emake DESTDIR="${ED}" docdir=/usr/share/doc/${PF} install

	if use qt6; then
		dosbin GUI/i7z_GUI
		if use policykit; then
			insinto /usr/share/polkit-1/actions
			doins "${FILESDIR}/i7z_GUI.policy"
			make_desktop_entry "pkexec --disable-internal-agent /usr/sbin/i7z_GUI" i7z kcmprocessor
		fi
	fi
}
