# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

DESCRIPTION="Arkanoid with Gnomes"
HOMEPAGE="https://jardinains2.com"
SRC_URI="mirror://gentoo/JN2_1_FREE_LIN.tar.gz"

LICENSE="jardinains"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="strip"

RDEPEND="
	acct-group/gamestat
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=virtual/glu-9.0-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]
	amd64? ( sys-libs/libstdc++-v3:5[multilib] )
"

dir=/opt/${PN}
QA_PREBUILT="${dir#/}/${PN}"
QA_EXECSTACK="${dir#/}${PN}/jardinains"

PATCHES=(
	"${FILESDIR}"/strings-pt.patch
)

src_unpack() {
	unpack JN2_1_FREE_LIN.tar.gz
	cd "${WORKDIR}" || die
	mv "Jardinains 2!" ${P} || die
}

src_prepare() {
	default

	# clean Mac fork files (bug #295782)
	find . -type f -name "._*" -exec rm -f '{}' + || die
}

src_install() {
	exeinto ${dir}
	doexe jardinains

	insinto ${dir}
	doins -r LICENSE.txt data help

	make_wrapper jardinains ./jardinains "${dir}" "${dir}"
	make_desktop_entry jardinains "Jardinains 2"
	touch "${ED}"/${dir}/data/prefs.xml || die

	chmod g+rw "${ED}"/${dir}/data/prefs.xml || die
	chmod -R g+rw "${ED}"/${dir}/data/players || die

	fperms -R 660 /opt/${PN}/data
	fowners -R root:gamestat /opt/${PN}/data /opt/${PN}/jardinains
	fperms g+s /opt/${PN}/${PN}
}

pkg_postinst() {
	elog "Due to the way this software is designed all user preferences for"
	elog "graphics, audio and other in game data are shared among all users"
	elog "of the computer."
}
