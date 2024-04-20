# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="1G"
inherit cdrom check-reqs

DESCRIPTION="A port of Jagged Alliance 2 to SDL (data files)"
HOMEPAGE="http://tron.homeunix.org/ja2/"
S="${WORKDIR}"

LICENSE="SIR-TECH"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
RESTRICT="bindist"

BDEPEND="app-arch/unshield"

src_unpack() {
	export CDROM_NAME="INSTALL_CD"

	cdrom_get_cds INSTALL/data1.cab

	# this makes some serious overhead
	unshield x "${CDROM_ROOT}"/INSTALL/data1.cab || die "unpacking failed"
}

src_prepare() {
	cd "${S}"/Ja2_Files/Data || die

	default

	local lower i
	# convert to lowercase
	find . \( -iname "*.jsd" -o -iname "*.wav" -o -iname "*.sti" -o -iname "*.slf" \) \
		-exec sh -c 'echo "${1}"
	lower="`echo "${1}" | tr [:upper:] [:lower:]`"
	[ -d `dirname "${lower}"` ] || mkdir `dirname ${lower}`
	[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;

	# remove possible leftover
	rm -r ./TILECACHE ./STSOUNDS || die
}

src_install() {
	insinto /usr/share/ja2/data
	doins -r "${S}"/Ja2_Files/Data/*
}

pkg_postinst() {
	elog "This is just the data portion of the game. You will need to install"
	elog "games-strategy/ja2-stracciatella to play the game."
}
