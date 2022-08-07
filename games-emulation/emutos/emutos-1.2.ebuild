# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_L10N=( cs:cz de es fi fr el:gr hu it nl no pl ru sv:se de-CH:sg tr en-GB:uk en:us )
MY_VERS=( 192k 256k 512k 1024k:etos aranym:emutos- )

DESCRIPTION="Single-user single-tasking operating system for 32-bit Atari computer emulators"
HOMEPAGE="http://emutos.sourceforge.net"
SRC_URI="$(printf "mirror://sourceforge/emutos/${PN}-%s-${PV}.zip " "${MY_VERS[@]%:*}")"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="$(printf 'l10n_%s ' "${MY_L10N[@]%:*}")"

BDEPEND="app-arch/unzip"

src_install() {
	local e list=()
	for e in "${MY_L10N[@]}"; do
		use l10n_${e%:*} && list+=( ${e#*:}.img )
	done
	(( ${#list[@]} )) || list=( us.img )

	insinto /usr/share/${PN}
	for e in "${MY_VERS[@]}"; do
		if [[ ${e} =~ : ]]; then
			doins ${PN}-${e%:*}-${PV}/${e#*:}${e%:*}.img # multilanguage
		else
			doins "${list[@]/#/${PN}-${e}-${PV}/etos${e%k}}" # single
		fi
		newdoc ${PN}-${e%:*}-${PV}/readme.txt readme-${e%:*}.txt
	done

	# These are identical for each, only need once.
	dodoc ${PN}-1024k-${PV}/doc/{announce,authors,bugs,changelog,emudesk,incompatible,status,todo,xhdi}.txt

	# Debug symbols usable by games-emulation/hatari (only provided with 1024k)
	doins ${PN}-1024k-${PV}/etos1024k.sym
}
